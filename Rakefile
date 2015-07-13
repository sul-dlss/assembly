require 'rake'
require 'rake/testtask'
require 'resque/tasks'
require 'robot-controller/tasks'

Dir.glob('lib/tasks/*.rake').each { |r| import r }

desc 'Get application version'
task :app_version do
  puts File.read(File.expand_path('../VERSION', __FILE__)).match('[\w\.]+')[0]
end

begin
  require 'rspec/core/rake_task'
  RSpec::Core::RakeTask.new(:spec)
rescue LoadError
end

task :default => :spec

task :environment do
  require_relative 'config/boot'
end
