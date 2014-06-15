set :stage, :production
set :branch, 'master'
set :rails_env, 'production'

server 'aninconvenientapp.com', user: 'steve', roles: %w{web app db}

 set :ssh_options, {
   forward_agent: true,
   auth_methods: %w(publickey password)
 }

fetch(:default_env).merge!(rails_env: :production)
