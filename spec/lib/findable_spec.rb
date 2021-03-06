# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Dor::Assembly::Findable do
  before do
    @cm_file_name = Dor::Config.assembly.cm_file_name
    @root_dir1 = Dor::Config.assembly.root_dir[0]
    @root_dir2 = Dor::Config.assembly.root_dir[1]
  end

  it 'computes the new druid tree path without checking for existence' do
    allow_any_instance_of(Dor::Assembly::Item).to receive(:check_for_path)
    @item = Dor::Assembly::Item.new(druid: 'xx111yy2222')
    expect(@item.druid_tree_path(@root_dir1)).to eq("#{@root_dir1}/xx/111/yy/2222/xx111yy2222")
  end

  it 'compute the old druid tree path without checking for existence' do
    allow_any_instance_of(Dor::Assembly::Item).to receive(:check_for_path)
    @item = Dor::Assembly::Item.new(druid: 'xx111yy2222')
    expect(@item.old_druid_tree_path(@root_dir2)).to eq("#{@root_dir2}/xx/111/yy/2222")
  end

  it 'should find the path to the content metadata file in the first possible root directory (older style)' do
    @item = Dor::Assembly::Item.new druid: 'druid:aa111bb2222'
    exp_cm_file = "#{@root_dir1}/aa/111/bb/2222/#{@cm_file_name}"
    expect(@item.cm_file_name).to eq(exp_cm_file)
    expect(@item.folder_style).to eq(:old)
    expect(@item.content_metadata_exists?).to be_truthy
    expect(@item.stub_content_metadata_exists?).to be_falsey
  end

  it 'should find the path to the content metadata file in the new location in the first possible root directory (new style)' do
    @item = Dor::Assembly::Item.new druid: 'druid:gg111bb2222'
    exp_cm_file = "#{@root_dir1}/gg/111/bb/2222/gg111bb2222/metadata/#{@cm_file_name}"
    expect(@item.cm_file_name).to eq(exp_cm_file)
    expect(@item.folder_style).to eq(:new)
    expect(@item.content_metadata_exists?).to be_truthy
    expect(@item.stub_content_metadata_exists?).to be_falsey
  end

  it 'should find the path to the content metadata file when in the second possible root directory' do
    @item = Dor::Assembly::Item.new druid: 'druid:aa222cc3333'
    exp_cm_file = "#{@root_dir2}/aa/222/cc/3333/#{@cm_file_name}"
    expect(@item.folder_style).to eq(:old)
    expect(@item.cm_file_name).to eq(exp_cm_file)
    expect(@item.content_metadata_exists?).to be_truthy
    expect(@item.stub_content_metadata_exists?).to be_truthy
  end

  it 'should find the path to the content metadata file when in the second possible root directory' do
    @item = Dor::Assembly::Item.new druid: 'druid:gg222cc3333'
    exp_cm_file = "#{@root_dir2}/gg/222/cc/3333/gg222cc3333/metadata/#{@cm_file_name}"
    expect(@item.cm_file_name).to eq(exp_cm_file)
    expect(@item.folder_style).to eq(:new)
    expect(@item.content_metadata_exists?).to be_truthy
    expect(@item.stub_content_metadata_exists?).to be_falsey
  end

  it 'should throw an exception when the object folder is found but the content metadata file is not found' do
    exp_msg = 'Content metadata file contentMetadata.xml not found for hh222cc4444 in any of the root directories: spec/test_input,spec/test_input2'
    @item = Dor::Assembly::Item.new druid: 'druid:hh222cc4444'
    expect { @item.load_content_metadata }.to raise_error RuntimeError, exp_msg
  end
end
