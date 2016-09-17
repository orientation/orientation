source 'https://rubygems.org'

ruby ENV['CUSTOM_RUBY_VERSION'] || '2.3.1'

gem 'rails', "5.0.0"
# Use Puma as the app server
gem 'puma', '~> 3.0'

# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.2'

gem 'pg'

gem 'autoprefixer-rails'
gem 'delayed_job'
gem 'delayed_job_active_record'
gem 'haml-rails'
gem 'simple_form', github: "olivierlacan/simple_form", branch: "rails-5-type-for-attribute"
gem 'pygments.rb'
gem 'redcarpet', '~> 3.3.4'
gem 'omniauth'
gem 'omniauth-google-oauth2'
gem 'activemodel-serializers-xml', github: 'rails/activemodel-serializers-xml'
gem 'draper', github: 'audionerd/draper', branch: 'rails5'
gem 'textacular', github: "textacular/textacular", branch: "master"
gem 'mandrill_mailer'
gem 'responders','~> 2.0'
gem 'bugsnag', require: false
gem 'slack-notifier'
gem 'friendly_id', github: "norman/friendly_id", branch: "master"
gem 'dotenv-rails'
gem 'redis', '~> 3.0'

group :development do
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'powder'
  gem 'bullet'
  gem 'fontcustom'
  gem 'web-console'
  gem 'listen', '~> 3.0.5'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'spring-commands-rspec'
end

group :development, :test do
  gem "rspec-rails"
  gem 'factory_girl_rails', '~> 4.5.0'
  gem 'faker'
  gem 'pry-rails'
  gem 'pry-byebug'
  gem 'pry-remote'
  gem 'awesome_print'
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
  gem 'skylight'
end
