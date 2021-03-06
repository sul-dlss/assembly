# frozen_string_literal: true

source 'https://rubygems.org'

gem 'assembly-image', '>=1.7.2'
gem 'assembly-objectfile', '>=1.6.6'
gem 'dor-services', '~> 6.0'
gem 'dor-services-client', '~> 1.0'
gem 'druid-tools'
gem 'honeybadger'
gem 'lyber-core', '>=4.1.3'
gem 'mini_exiftool', '>= 1.6', '< 3'
gem 'nokogiri', '>=1.8.1'
gem 'pry-rescue'
gem 'pry-stack_explorer'
gem 'rake'
gem 'resque'
gem 'rest-client', '>=1.8'
gem 'robot-controller', '~> 2.0'
gem 'rubocop', '~> 0.61.0' # avoid code churn due to rubocop upgrades
gem 'slop'

group :test do
  gem 'byebug'
  gem 'coveralls', require: false
  gem 'equivalent-xml'
  gem 'rspec', '~> 3.4'
  gem 'simplecov'
  gem 'webmock'
end

group :deployment do
  gem 'capistrano', '~> 3'
  gem 'capistrano-bundler'
  gem 'capistrano-rvm'
  gem 'dlss-capistrano', '~> 3'
end

group :development do
  gem 'awesome_print'
end
