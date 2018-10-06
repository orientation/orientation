source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby ENV['CUSTOM_RUBY_VERSION'] || '2.4.4'

gem 'rails', "~> 5.2.0"

# Use Puma as the app server
gem 'puma', '~> 3.0'

# Use SCSS for stylesheets
gem 'sass-rails'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier'

# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'mini_racer', platforms: :ruby

# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.2'

# Use Haml as a replacement for ERB view templates
gem 'haml-rails'

# Icon fonts
gem 'font-awesome-sass'

# PostgreSQL
gem 'pg'

# Autoprefixer
gem 'autoprefixer-rails'

# Job queueing with Sidekiq (requires Redis)
gem 'sidekiq'

# Job uniqueness & locking
gem 'sidekiq-unique-jobs'

# Form builder
gem 'simple_form'

# Server-side syntax highlighting
gem 'pygments.rb'

# Markdown parsing and rendering
gem 'redcarpet', '~> 3.4.0'

# OAuth integration
gem 'omniauth'
gem 'omniauth-google-oauth2'

# Full-text search with PostgreSQL
gem 'pg_search'

gem 'activemodel-serializers-xml'

# Decorators
gem 'draper', '~> 3.0.0'

# Default responses from controllers
gem 'responders','~> 2.0'

# Friendly URL slugs for models
gem 'friendly_id'

# Environment variables from .env files
gem 'dotenv-rails'

# ActionCable dependency
gem 'redis', '~> 3.0'

# === Third-party Integrations === #

# Exception reporter (see orientation.yml)
gem 'bugsnag'

# Article activity Slack notifications
gem 'slack-notifier'

# Transactional emails (see orientation.yml)
gem 'mandrill_mailer'

gem 'factory_bot_rails'
gem 'faker'

# Use ActiveStorage variant
# gem 'mini_magick', '~> 4.8'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.1.0', require: false

group :development do
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'listen'
  gem 'spring'
  gem 'spring-watcher-listen'
  gem 'derailed_benchmarks'
  gem 'stackprof'
end

group :development, :test do
  gem 'rspec-rails'
  gem 'spring-commands-rspec'

  gem 'pry-rails'
  gem 'pry-byebug'
  gem 'pry-remote'
  gem 'awesome_print'
end

group :test do
  gem 'database_cleaner'
  gem 'capybara'
  gem 'capybara-screenshot'
  gem 'launchy'
  gem 'climate_control'

  # === Third-party integrations === #

  # Code Climate test coverage reporting
  gem 'codeclimate-test-reporter', require: nil
end

group :production, :staging do
  gem 'rails_12factor'
  gem 'rack-timeout'

  # == Third-party Integrations == #

  # Performance monitoring
  gem 'skylight'
end
