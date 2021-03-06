# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Dor::Assembly::Checksumable do
  def basic_setup(dru, root_dir = Dor::Config.assembly.root_dir)
    @item              = Dor::Assembly::Item.new(druid: dru)
    @item.root_dir     = root_dir
    @item.cm           = Nokogiri::XML '<contentMetadata><file></file></contentMetadata>'
    @item.path_to_object # this will find the path to the object and set the folder_style -- it is only necessary to call this in test setup
    # since we don't actually call the Dor::Assembly::Item initializer in tests like we do actual code (where it does get called)
    @fake_checksum_data = { md5: 'a123', sha1: '567c' }
    @parent_file_node   = @item.cm.xpath('//file').first
  end

  def all_cs_nodes
    @item.cm.xpath '//file/checksum'
  end

  def all_file_nodes
    @item.cm.xpath '//file'
  end

  def setup_tmp_handle
    @tmpfile = Tempfile.new 'persist_content_metadata_', 'tmp'
    @item.cm_handle = @tmpfile
  end

  describe '#ChecksumableItem' do
    it 'should be able to initialize our testing object' do
      basic_setup('aa111bb2222')
      expect(@item).to be_a_kind_of Dor::Assembly::Item
    end
  end

  describe '#compute_checksums' do
    it 'should update the content metadata correctly, adding checksums where they are missing, and leaving any existing checksums intact' do
      basic_setup('aa111bb2222')
      setup_tmp_handle

      @item.load_content_metadata
      expect(all_cs_nodes.size).to eq(5)
      @item.compute_checksums
      expect(all_cs_nodes.size).to eq(8)

      @exp_checksums = {
        'image111.tif' => {
          'md5' => '42616f9e6c1b7e7b7a71b4fa0c5ef794',
          'sha1' => '77795223379bdb0ded2bd5b8a63adc07fb1c3484'
        },
        'image112.tif' => {
          'md5' => 'ac440802bd590ce0899dafecc5a5ab1b',
          'sha1' => '5c9f6dc2ca4fd3329619b54a2c6f99a08c088444',
          'foo' => 'FOO', 'bar' => 'BAR'
        },
        'sub/image113.tif' => {
          'md5' => 'ac440802bd590ce0899dafecc5a5ab1b',
          'sha1' => '5c9f6dc2ca4fd3329619b54a2c6f99a08c088444'
        }
      }

      all_file_nodes.each do |fnode|
        file_name = fnode['id']
        cnodes    = fnode.xpath './checksum'
        checksums = Hash[cnodes.map { |cn| [cn['type'], cn.content] }]
        expect(checksums).to eq(@exp_checksums[file_name])
      end
    end

    it 'should update the content metadata correctly in the new location, adding checksums where they are missing, and leaving any existing checksums intact' do
      basic_setup('gg111bb2222')
      setup_tmp_handle

      @item.load_content_metadata
      expect(all_cs_nodes.size).to eq(4)
      @item.compute_checksums
      expect(all_cs_nodes.size).to eq(7)

      @exp_checksums = {
        'image111.tif' => {
          'md5' => '42616f9e6c1b7e7b7a71b4fa0c5ef794',
          'sha1' => '77795223379bdb0ded2bd5b8a63adc07fb1c3484'
        },
        'image112.tif' => {
          'md5' => 'ac440802bd590ce0899dafecc5a5ab1b',
          'sha1' => '5c9f6dc2ca4fd3329619b54a2c6f99a08c088444',
          'bar' => 'BAR'
        },
        'sub/image113.tif' => {
          'md5' => 'ac440802bd590ce0899dafecc5a5ab1b',
          'sha1' => '5c9f6dc2ca4fd3329619b54a2c6f99a08c088444'
        }
      }

      all_file_nodes.each do |fnode|
        file_name = fnode['id']
        cnodes    = fnode.xpath './checksum'
        checksums = Hash[cnodes.map { |cn| [cn['type'], cn.content] }]
        expect(checksums).to eq(@exp_checksums[file_name])
      end
    end

    it 'should not fail when an existing md5 checksum matches but is CAP CASE' do
      basic_setup('aa111bb2222')
      setup_tmp_handle

      @item.load_content_metadata

      all_file_nodes[0].xpath('checksum[@type="md5"]')[0].content = '42616f9E6C1B7E7B7A71B4FA0C5Ef794' # change the md5 hash in the first file node to be all caps
      expect(all_cs_nodes.size).to eq(5)

      # now check that it was re-computed and still succeeds
      expect { @item.compute_checksums }.not_to raise_error

      # this was the first file node it got to, so no new checksums were added
      expect(all_cs_nodes.size).to eq(8)
    end

    it 'should fail when an existing md5 checksum does not match' do
      basic_setup('aa111bb2222')
      setup_tmp_handle

      @item.load_content_metadata

      all_file_nodes[0].xpath('checksum[@type="md5"]')[0].content = 'flimflam' # change the md5 hash in the first file node
      expect(all_cs_nodes.size).to eq(5)

      # now check that it was re-computed and failed
      exp_msg = /^Checksums disagree: type="md5", file="image111.tif"./
      expect { @item.compute_checksums }.to raise_error RuntimeError, exp_msg

      # this was the first file node it got to, so no new checksums were added before it failed
      expect(all_cs_nodes.size).to eq(5)
    end

    it 'should fail when an existing md5 checksum does not match with content metadata in new location' do
      basic_setup('gg111bb2222')
      setup_tmp_handle

      @item.load_content_metadata

      all_file_nodes[0].xpath('checksum[@type="md5"]')[0].content = 'flimflam' # change the md5 hash in the first file node
      expect(all_cs_nodes.size).to eq(4)

      # now check that it was re-computed and failed
      exp_msg = /^Checksums disagree: type="md5", file="image111.tif"./
      expect { @item.compute_checksums }.to raise_error RuntimeError, exp_msg

      # this was the first file node it got to, so no new checksums were added before it failed
      expect(all_cs_nodes.size).to eq(4)
    end

    it 'should fail when an existing sha1 checksum does not match, but continue to add checksums to other missing nodes before that' do
      basic_setup('aa111bb2222')
      setup_tmp_handle

      @item.load_content_metadata
      all_file_nodes[1].xpath('checksum[@type="sha1"]')[0].content = 'crapola' # change the md5 hash in the first file node

      expect(all_cs_nodes.size).to eq(5)

      # now check that it was re-computed and failed
      exp_msg = /^Checksums disagree: type="sha1", file="image112.tif"./
      expect { @item.compute_checksums }.to raise_error RuntimeError, exp_msg

      # at this point it added a sha1 checksum to the first file node already
      expect(all_cs_nodes.size).to eq(6)
    end

    it 'should fail when any existing md5 checksum does not match (even when there are multiple for a given file node)' do
      basic_setup('aa111bb2222')
      setup_tmp_handle

      @item.load_content_metadata

      # start out with 5 checksum nodes
      expect(all_cs_nodes.size).to eq(5)

      # keep the correct first md5 checksum for the first file, but add a bogous one too
      @item.add_checksum_node @item.cm.xpath('//file').first, 'md5', 'junk'

      # we now have six checksum nodes
      expect(all_cs_nodes.size).to eq(6)

      # now check that it was re-computed and failed, even though the first still matches
      exp_msg = /^Checksums disagree: type="md5", file="image111.tif"./
      expect { @item.compute_checksums }.to raise_error RuntimeError, exp_msg

      # this was the first file node it got to, so no new checksums were added before it failed
      expect(all_cs_nodes.size).to eq(6)
    end
  end

  describe '#add_checksum_nodes' do
    it 'should correctly add checksum nodes as children of the parent_node' do
      basic_setup('aa111bb2222')

      expect(all_cs_nodes.size).to eq(0)
      @item.add_checksum_node @parent_file_node, 'md5', @fake_checksum_data[:md5]
      @item.add_checksum_node @parent_file_node, 'sha1', @fake_checksum_data[:sha1]
      expect(all_cs_nodes.size).to eq(2)
      h = Hash[all_cs_nodes.map { |n| [n['type'].to_sym, n.content] }]
      expect(h).to eq(@fake_checksum_data)
    end
  end
end
