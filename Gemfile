source 'https://rubygems.org'

ruby '2.0.0'

gem 'rails', '~> 4.0.0'
gem 'railties', '~> 4.0.0'

gem 'pg'
gem 'thin'

gem 'uglifier', '>= 1.3.0'
gem 'jquery-rails'
gem 'jquery-ui-rails'
gem 'sass-rails'

gem 'turbolinks'

gem 'bourbon'
gem 'coffee-rails'
gem 'haml-rails'
gem 'simple_form'
gem 'pygments.rb'
gem 'redcarpet'
gem 'omniauth'
gem 'omniauth-google-oauth2'
gem 'draper', '~> 1.2.1'
gem 'rails_tokeninput'
gem 'momentjs-rails', '2.0.0.1'
gem 'textacular', require: 'textacular/rails'

# monitoring
gem "sentry-raven", :git => "https://github.com/getsentry/raven-ruby.git"

group :development do
  gem 'fuubar'
  gem 'better_errors'
  gem 'binding_of_caller'
end

group :development, :test do
  gem 'dotenv-rails'
  gem 'rspec-rails', '~> 2.13.0'
  gem 'factory_girl_rails', '~> 4.2.1'
  gem 'pry-rails'
  gem 'pry-debugger', platform: :ruby_19
  gem 'pry-remote'
end

group :test do
  gem 'shoulda-matchers', '~> 1.5.6' # path: "~/Development/opensource/shoulda-matchers", branch: "rails4"
  gem 'capybara', github: "jnicklas/capybara", branch: "master"
end