require 'bundler/capistrano'

set :application, "datenightexchange"
set :repository,  "git@github.com:charlesmaxwood/datenightexchange.git"

set :scm, :git
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

default_run_options[:pty] = true
set :use_sudo, false

task :stage do
  set :deploy_to, '/var/www/datenightexchange/'
  set :user, 'deploy'
  role :web, "intentionalexcellence.net"                          # Your HTTP server, Apache/etc
  role :app, "intentionalexcellence.net"                          # This may be the same as your `Web` server
  role :db,  "intentionalexcellence.net", :primary => true # This is where Rails migrations will runexit
  
  after "deploy:symlink", "deploy:link_config"
  after "deploy:link_config", "deploy:migrate"
  after "deploy:migrate", "deploy:seed"
end

set :deploy_via, :remote_cache


# If you are using Passenger mod_rails uncomment this:
# if you're still using the script/reapear helper you will need
# these http://github.com/rails/irs_process_scripts

namespace :deploy do
  task :migrate do
    run "#{try_sudo} cd #{deploy_to}current && RAILS_ENV=production rake db:migrate"
  end

  task :seed do
    run "#{try_sudo} cd #{deploy_to}current && RAILS_ENV=production rake db:seed"
  end

  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
  task :link_config do
    run "#{try_sudo} ln -nfs #{deploy_to}shared/database.yml #{deploy_to}current/config/database.yml"
  end
end
