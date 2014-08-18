server 'sul-robots1-dev.stanford.edu', user: 'lyberadmin', roles: %w{web app db}
server 'sul-robots2-dev.stanford.edu', user: 'lyberadmin', roles: %w{web app db}
server 'sul-robots3-dev.stanford.edu', user: 'lyberadmin', roles: %w{web app db}
server 'sul-robots4-dev.stanford.edu', user: 'lyberadmin', roles: %w{web app db}
server 'sul-robots5-dev.stanford.edu', user: 'lyberadmin', roles: %w{web app db}

Capistrano::OneTimeKey.generate_one_time_key!

set :branch, 'dev-deploy'
set :default_env, { :robot_environment => fetch(:deploy_environment) }
