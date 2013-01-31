require 'rvm/capistrano'
require "bundler/capistrano"

# --------------------------------------------------------------------- DEFAULTS
default_run_options[:pty] = true
# set :default_environment, {
#   'PATH' => "/opt/ruby-ee/bin/:$PATH"
# }

# ------------------------------------------------------------ DEPLOYMENT PARAMS
set :application, "slideshot"

role :web, "thot.epfl.ch"
role :app, "thot.epfl.ch"
role :db,  "thot.epfl.ch", :primary => true  # where migration are executed
# role :db,  "your slave db-server here"

set :deploy_to, "/var/www/thot/prod"
set :user, "root"
set :use_sudo, false
set :keep_releases, 3
# set :normalize_asset_timestamps, false

set :scm, :git
set :repository,  " ssh://cangiani@lth.epfl.ch/repos/git/thot.git"
set :branch, "master"
set :scm_username, "cangiani"
set :scm_passphrase, Proc.new { Capistrano::CLI.password_prompt "SCM Password: " }

# ------------------------------------------------------------------------- DEPS
# after 'deploy:finalize_update', 'deploy:make_symlinks'

# -------------------------------------------------------------------------- RVM
# set :rvm_ruby_string, ENV['GEM_HOME'].gsub(/.*\//,"")
set :rvm_ruby_string, 'ruby-1.9.3'
set :rvm_type, :system                          # or :user
set :rvm_install_type, :stable                  # or :head
set :rvm_install_pkgs, %w[libyaml openssl]
set :rvm_install_ruby_params, '--with-opt-dir=/usr/local/rvm/usr'
set :rvm_install_ruby_threads, 4

# -------------------------------------------------------------------- PASSENGER
# If you are using Passenger mod_rails uncomment this:
namespace :deploy do
  task :start do ; end
  task :stop do ; end

  desc "Restart Passenger"
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end

# ----------------------------------------------------------------- DEPLOY TASKS
namespace :deploy do

  desc "Create symlinks to upload/download folders in public"
  task :make_symlinks do
    run "ln -nfs #{shared_path}/uploads  #{release_path}/public/uploads"
    run "ln -nfs #{shared_path}/downloads  #{release_path}/public/downloads"
  end

end

# -------------------------------------------------------------------- APP TASKS
namespace :app do
  desc "Open the rails console on one of the remote servers"
  task :console, :roles => :app do
    exec %{ssh #{domain} -t "#{default_shell} -c 'cd #{current_path} && bundle exec rails c #{rails_env}'"}
  end

  desc "remote rake task"
  task :rake do
    run "cd #{deploy_to}/current; RAILS_ENV=#{rails_env} rake #{ENV['TASK']}"
  end
end

# ------------------------------------------------------------------ MAINTENANCE
desc <<-DESC
  Present a maintenance page to visitors. Disables your application's web \
  interface by writing a "maintenance.html" file to each web server. The \
  servers must be configured to detect the presence of this file, and if \
  it is present, always display it instead of performing the request.

  Options: REASON, UNTIL as in the following example:

    $ cap maintenance_up \\
          REASON="a hardware upgrade" \\
          UNTIL="12pm Central Time"
DESC
task :maintenance_up, :roles => :web do
  on_rollback { run "rm #{shared_path}/system/maintenance.html" }

  require 'erb'
  deadline, reason = ENV['UNTIL'], ENV['REASON']

  template = File.read('app/views/errors/maintenance.html.erb')
  page = ERB.new(template).result(binding)
  put page, "#{shared_path}/system/maintenance.html", :mode => 0644
end

desc "Stop maintenance mode by removing the maintenance.html file"
task :maintenance_down, :roles => :web do
  run "rm #{shared_path}/system/maintenance.html"
end
