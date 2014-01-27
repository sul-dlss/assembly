source 'https://rubygems.org'
source 'http://sul-gems.stanford.edu'

# Let's require at least ruby 1.9, but allow ruby 2.0 too
ruby "1.9.3" if RUBY_VERSION < "1.9"

gem "lyber-core"
gem "assembly-objectfile"
gem "assembly-image", ">=1.6.3"
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
  gem 'yard'
end

group :development do
  gem 'lyberteam-capistrano-devel', '>= 1.1.0'
  gem "capistrano", "< 3"
  gem "rvm-capistrano"
  gem 'awesome_print'
end

gem 'net-ssh-kerberos', :platform => :ruby_18
gem 'net-ssh-krb', :platform => :ruby_19
gem 'gssapi', :github => 'cbeer/gssapi'
