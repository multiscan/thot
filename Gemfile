source 'https://rubygems.org'


# -------------------------------------------------------------- BASE RAILS GEMS
gem 'rails', '3.2.9'
gem 'jquery-rails'
gem 'sqlite3'
gem 'mysql2'
gem 'activerecord-mysql-adapter'
gem 'memoist'

gem 'haml-rails', :group => :development
gem 'thin'

# ---------------------------------------------------- CAPISTRANO FOR DEPLOYMENT
gem 'capistrano'
gem 'rvm-capistrano'

# ------------------------------------------------------------ APP SPECIFIC GEMS

# authentication
gem "devise", ">= 2.1.2"
gem "cancan", ">= 1.6.8"
gem "rolify", ">= 3.2.0"

# app configuration: config/application.yml
gem "figaro", ">= 0.5.0"

# view helpers
gem "bootstrap-sass", ">= 2.1.1.0"
gem "simple_form", ">= 2.0.4"
gem 'will_paginate', '~> 3.0'
gem "better_errors", ">= 0.2.0", :group => :development

gem "turbolinks"

# http://www.mcbsys.com/techblog/2012/10/convert-a-select-drop-down-box-to-an-autocomplete-in-rails/
# gem 'rails3-jquery-autocomplete'   # 1.0.10
gem 'rails3-jquery-autocomplete', '1.0.9'

group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'uglifier', '>= 1.0.3'
end

group :development do
  gem "quiet_assets", ">= 1.0.1"
  gem "binding_of_caller", ">= 0.6.8"
end

group :development, :test do
  gem "rspec-rails", ">= 2.11.4", :group => [:development, :test]
  gem "factory_girl_rails", ">= 4.1.0", :group => [:development, :test]
end

group :test do
  gem "cucumber-rails", ">= 1.3.0", :require => false
  gem "database_cleaner", ">= 0.9.1"
  gem "email_spec", ">= 1.4.0"
  gem "launchy", ">= 2.1.2"
  gem "capybara", ">= 2.0.1"
end

# For searching book infos on the web https://github.com/jayfajardo/openlibrary
gem 'openlibrary'
gem 'lcclasses'   # library of congress classes (to parse output from loc query)
gem "nokogiri"

# # Search logic: planty of helpers for searching only for rails 2   :(
# gem 'searchlogic'

# Full text search with Thinking Sphinx. DB must be under mysql or postgresql.
# http://pat.github.com/ts/en/
# http://railscasts.com/episodes/120-thinking-sphinx
# --------------------
# Devel install on mac
# --------------------
# brew install mysql
# mysql_install_db --verbose --user=`whoami` --basedir="$(brew --prefix mysql)" --datadir=/usr/local/var/mysql --tmpdir=/tmp
# mysql.server start
# /usr/local/opt/mysql/bin/mysql_secure_installation
# brew install sphinx --mysql
# rake thinking_sphinx:index
# rake thinking_sphinx:rebuild
# rake thinking_sphinx:start
gem 'thinking-sphinx', '2.0.10'


# -------------------------------------------------------------------- REMIND ME
# gem 'formtastic'
# gem 'formtastic-bootstrap'
# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'
# To use Jbuilder templates for JSON
# gem 'jbuilder'
# Use unicorn as the app server
# gem 'unicorn'
# To use debugger
gem 'debugger', :group => [:development]
gem 'cheat', :group => [:development]

