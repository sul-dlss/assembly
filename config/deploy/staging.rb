server 'sul-robots1-test.stanford.edu', user: 'lyberadmin', roles: %w{web app db}
server 'sul-robots2-test.stanford.edu', user: 'lyberadmin', roles: %w{web app db}
server 'sul-robots3-test.stanford.edu', user: 'lyberadmin', roles: %w{web app db}
server 'sul-robots4-test.stanford.edu', user: 'lyberadmin', roles: %w{web app db}
server 'sul-robots5-test.stanford.edu', user: 'lyberadmin', roles: %w{web app db}

Capistrano::OneTimeKey.generate_one_time_key!

set :deploy_environment, 'test'
set :default_env, { :robot_environment => fetch(:deploy_environment) }