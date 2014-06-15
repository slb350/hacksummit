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

desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      # Your restart mechanism here, for example:
      # execute :touch, release_path.join('tmp/restart.txt')
    end
  end

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end

  after :finishing, 'deploy:cleanup'

end