source :rubygems
source "http://sulair-rails-dev.stanford.edu"

gem "lyber-core"
gem "checksum-tools"
gem "assembly-image", ">= 0.1.3"

group :test do
  gem "rake"
  gem "rcov"
  gem "rspec", "~> 2.6"
  gem 'equivalent-xml'
end

group :development do
  if File.exists?(mygems = File.join(ENV['HOME'],'.gemfile'))
    instance_eval(File.read(mygems))
  end
  gem "ruby-debug"
  gem "capistrano", "2.9.0"
  gem "lyberteam-devel"
end

