$:.unshift File.expand_path(File.join(File.dirname(__FILE__), "..", "lib"))
$:.unshift File.expand_path(File.join(File.dirname(__FILE__), "..", "robots"))

require 'rubygems'
require 'bundler/setup'
require 'logger'

# Load the environment file based on Environment.  Default to development
environment = ENV['ROBOT_ENVIRONMENT'] ||= 'development'
ROBOT_ROOT = File.expand_path(File.dirname(__FILE__) + "/..")
ROBOT_LOG = Logger.new(File.join(ROBOT_ROOT, "log/#{environment}.log"))
ROBOT_LOG.level = Logger::SEV_LABEL.index(ENV['ROBOT_LOG_LEVEL']) || Logger::INFO

# Override Solrizer's logger before it gets a chance to load and pollute
# STDERR.
begin
  require 'solrizer'
  Solrizer.logger = ROBOT_LOG
rescue LoadError, NameError, NoMethodError
end

require 'dor-services'
require 'lyber_core'

# TODO Maybe move auto-require to just run_robot and spec_helper?
Dir["#{ROBOT_ROOT}/lib/**/*.rb"].each { |f| require f }
Dir["#{ROBOT_ROOT}/robots/*"].select { |f| File.directory?(f) }.each do |dir|
  module_name = File.basename(dir).split(/_/).map {|s| s.capitalize}.join('')
  mod = Module.new
  Dir["#{dir}/*.rb"].each do |robot_file|
    robot_name = File.basename(robot_file,'.rb').split(/_/).collect { |p| p.capitalize }.join('')
    mod.autoload robot_name.to_sym, robot_file
  end
  Object.const_set(module_name.to_sym, mod)
end

env_file = File.expand_path(File.dirname(__FILE__) + "/./environments/#{environment}")
puts "Loading config from #{env_file}"
require env_file