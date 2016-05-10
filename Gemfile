source 'https://rubygems.org'

ruby ENV['CUSTOM_RUBY_VERSION'] || '2.3.0'

gem 'rails', "5.0.0.racecar1"
# Use Puma as the app server
gem 'puma'

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
gem 'simple_form', github: 'kesha-antonov/simple_form', branch: 'rails-5-0'
gem 'pygments.rb'
gem 'redcarpet', '~> 3.3.4'
gem 'omniauth'
gem 'omniauth-google-oauth2'
gem 'activemodel-serializers-xml', github: 'rails/activemodel-serializers-xml'
gem 'draper', github: 'audionerd/draper', branch: 'rails5'
gem 'textacular'
gem 'mandrill_mailer', '~> 1.4.0'
gem 'responders','~> 2.0'
gem 'bugsnag'
gem 'slack-notifier'
gem 'friendly_id'
gem 'dotenv-rails'
gem 'redis'

group :development do
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'powder'
  gem 'bullet'
  gem 'quiet_assets'
  gem 'fontcustom'
  gem 'web-console'
end

group :development, :test do
  # gem 'rspec-rails'
  gem "rspec-rails", git: "https://github.com/rspec/rspec-rails.git", branch: "master"
  gem "rspec-core", git: "https://github.com/rspec/rspec-core.git", branch: "master"
  gem "rspec-support", git: "https://github.com/rspec/rspec-support.git", branch: "master"
  gem "rspec-expectations", git: "https://github.com/rspec/rspec-expectations.git", branch: "master"
  gem "rspec-mocks", git: "https://github.com/rspec/rspec-mocks.git", branch: "master"
  gem 'spring-commands-rspec'
  gem 'factory_girl_rails', '~> 4.5.0'
  gem 'faker'
  gem 'pry-rails'
  gem 'pry-byebug'
  gem 'pry-remote'
  # Access an IRB console on exception pages or by using <%= console %> in views
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
  gem 'skylight'
end
