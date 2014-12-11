source 'https://rubygems.org'

# -------------------------------------------------------------- BASE RAILS GEMS
gem 'rails', '4.0.0'
gem 'sqlite3'
gem 'mysql2', '~>0.3.12b4'
gem 'activerecord-mysql-adapter'

group :production do
  gem "therubyracer", :require => 'v8'
end

# ---------------------------------------------------- CAPISTRANO FOR DEPLOYMENT
gem 'capistrano', '>=2.15.4'
gem 'rvm-capistrano'

# ------------------------------------------------------------ APP SPECIFIC GEMS

# --- xml parsing
# gem "nokogiri"
gem "ox", "~> 2.0.3"

# --- sphinx full text search
gem 'thinking-sphinx', '~>3.0.3'

# --- authentication and acl
#gem "devise_invitable", '~> 1.1.0'
gem "devise", github: 'plataformatec/devise'
gem "cancan", ">= 1.6.8"
gem "rolify", ">= 3.2.0"

# --- app configuration: config/application.yml
gem "figaro", ">= 0.6.0"

# --- static pages
gem 'high_voltage'

# TODO: re-enable autocomplete when a rails4 compatible version is out
# gem 'rails3-jquery-autocomplete', github: 'francisd/rails3-jquery-autocomplete'

# --------------------------------------------------------------------------- js
gem 'jquery-rails'
gem 'jquery-ui-rails'

# --- for easily passing variables to javascript
# http://railscasts.com/episodes/324-passing-data-to-javascript
# https://github.com/gazay/gon
gem 'gon'

# -------------------------------------------------------------------- rendering
# --- PDF rendering
gem 'prawn'
gem 'prawn-table'
gem 'prawn_rails'

# --- markdown rendering
gem 'bluecloth'

# --- html and css
gem 'haml-rails', '~>0.4'
gem 'sass-rails'               #, '~>4.0.0'
gem 'coffee-rails'             #, '~>4.0.0'
gem 'uglifier', '>= 1.3.0'

# ----------------------------------------------------------------- view helpers
gem "simple_form", github: 'plataformatec/simple_form'
gem 'will_paginate', '~> 3.0.3'
gem 'will_paginate-bootstrap'
gem 'bootstrap-sass', '~> 2.3.2.0' # https://github.com/thomas-mcdonald/bootstrap-sass
# ------------------------------------------------------------------------ devel

gem 'memoist'

group :development do
  gem 'thin'
  gem "quiet_assets", ">= 1.0.1"
  gem "binding_of_caller", ">= 0.6.8"
  gem "better_errors", ">= 0.2.0"
end

# ---------------------------------------------------------------------- testing
group :test do
  # gem 'minitest'
  gem 'capybara'
  # gem 'turn'
end

# ------------------------------------------------------------------------ NOTES

# For searching book infos on the web
# gem 'openlibrary' # https://github.com/jayfajardo/openlibrary
# gem 'lcclasses'   # library of congress classes (to parse output from loc query)
