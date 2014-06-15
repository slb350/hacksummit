set :application, 'aninconvenientapp'
set :repo_url, 'git@github.com:slb350/hacksummit.git'
set :user, 'steve'
set :deploy_to, "/home/#{fetch(:user)}/apps/#{fetch(:application)}"
set :releases_directory, "/home/#{fetch(:user)}/apps/#{fetch(:application)}/releases"
set :deploy_via, :remote_cache
set :use_sudo, false
set :pty, true

set :keep_releases, 2
set :linked_files, %w[config/database.yml config/secrets.yml]
set :linked_dirs, %w[tmp/cache]

namespace :deploy do

desc 'Restart Rails Services'
  task :rails_restart do
    on roles(:all), in: :sequence, wait: 5 do
      command "cd /home/#{fetch(:user)/rails.sh}"
    end
  end


  after :finishing, 'rails_restart'

end
