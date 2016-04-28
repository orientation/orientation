source 'https://rubygems.org'

ruby ENV['CUSTOM_RUBY_VERSION'] || '2.3.0'

gem 'rails', '~> 4.2.6'

# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.1.0'

gem 'pg'

gem 'autoprefixer-rails'
gem 'delayed_job'
gem 'delayed_job_active_record'
gem 'haml-rails'
gem 'simple_form'
gem 'pygments.rb'
gem 'redcarpet', '~> 3.3.4'
gem 'omniauth'
gem 'omniauth-google-oauth2'
gem 'draper'
gem 'textacular'
gem 'mandrill_mailer', '~> 1.1.0'
gem 'responders','~> 2.0'
gem 'skylight'
gem 'bugsnag'
gem 'slack-notifier'
gem 'friendly_id'
gem 'dotenv-rails'

group :development do
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'powder'
  gem 'bullet'
  gem 'quiet_assets'
  gem 'fontcustom'
end

group :development, :test do
  gem 'rspec-rails', '~> 3.2.0'
  gem 'spring-commands-rspec'
  gem 'factory_girl_rails', '~> 4.5.0'
  gem 'faker'
  gem 'pry-rails'
  gem 'pry-byebug'
  gem 'pry-remote'
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'
  gem 'spring'
end

group :test do
  gem 'database_cleaner'
  gem 'capybara'
  gem 'launchy'
  gem 'codeclimate-test-reporter', require: nil
  gem 'climate_control'
end

group :production, :staging do
  gem 'rails_12factor'
  gem 'rack-timeout'
  gem 'unicorn'
end
