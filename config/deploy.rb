# require 'capistrano/bundler'

set :application, 'iConfConnect'
set :repo_url, 'https://github.com/vinsol/iconfconnect-web-app.git'


set :deploy_to, '/home/deploy/iConfConnect'

#set :linked_files, %w{config/database.yml}
set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

namespace :deploy do

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      execute :touch, release_path.join('tmp/restart.txt')
    end
  end

  after :publishing, 'deploy:restart'
  after :finishing, 'deploy:cleanup'
end