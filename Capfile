# Initial deployment.
#
# 1) Setup directory structure on remote VM.
#
#    $ cap dev deploy:setup
#
# 2) Manually copy files to $application/shared.
# 
#       - environment-specific configuration to config/environments.  
#       - certs to config/certs.
#
# Subsequent deployments:
#
#   # Stop robots, deploy code, start robots.
#   $ cap dev deploy
#
#   # Stop robots, deploy code.
#   $ cap dev deploy:update
#
#   # Start robots.
#   $ cap dev deploy:start

load 'deploy' if respond_to?(:namespace) # cap2 differentiator
require 'dlss/capistrano/robots'

set :application,     'assembly'
set :git_subdir,      "lyberteam/#{application}.git"
set :rvm_ruby_string, "1.8.7@#{application}"

task :dev do
  role :app, 'lyberservices-dev.stanford.edu'
  set :deploy_env, 'development'
  set :bundle_without, []         # Deploy all gem groups on the dev VM.
end

task :testing do
  role :app, 'lyberservices-test.stanford.edu'
  set :deploy_env, 'test'
end

task :production do
  role :app, 'lyberservices-prod.stanford.edu'
  set :deploy_env, 'production'
end

set :sunet_id,   Capistrano::CLI.ui.ask('SUNetID: ') { |q| q.default =  `whoami`.chomp }
set :rvm_type,   :user
set :user,       'lyberadmin' 
set :repository, "ssh://#{sunet_id}@corn.stanford.edu/afs/ir/dev/dlss/git/#{git_subdir}"
set :deploy_to,  "/home/#{user}/#{application}"
set :deploy_via, :copy
set :shared_config_certs_dir, true

# Robots run as background daemons. They are restarted at deploy time.
set :robots, %w(jp2-create checksum checksum-compare)
set :workflow, 'assemblyWF'