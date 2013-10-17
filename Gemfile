source 'https://rubygems.org'
source 'http://sul-gems.stanford.edu'

gem "lyber-core"
gem "assembly-objectfile"
gem "assembly-image"
gem "assembly-utils"
gem "rest-client"
gem "rake"
gem "druid-tools"
gem "mini_exiftool", "~> 1.6"
gem "dor-services", ">= 4.3.2"
gem "nokogiri"
gem "activesupport"
gem "actionpack"
gem "actionmailer"

group :test do
  gem "rspec", "~> 2.6"
  gem 'equivalent-xml'
end

group :development do
  if File.exists?(mygems = File.join(ENV['HOME'],'.gemfile'))
    instance_eval(File.read(mygems))
  end
  gem "capistrano", "< 3"
  gem "rvm-capistrano"
	gem 'lyberteam-capistrano-devel', '>= 1.1.0'
  gem 'net-ssh-krb', :platform => :ruby_19
  gem 'gssapi', :github => 'cbeer/gssapi', :platform => :ruby_19
end
