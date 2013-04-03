source 'https://rubygems.org'

ruby '2.0.0'

gem 'rails', '~> 4.0.0.beta1'
gem 'railties', '~> 4.0.0.beta1'

gem 'pg'
gem 'thin'

group :assets do
  gem 'sprockets-rails', github: 'rails/sprockets-rails'
  gem 'coffee-rails', github: 'rails/coffee-rails'

  gem 'uglifier', '>= 1.0.3'
end

# Heroku precompile fun
gem 'sass-rails', github: 'rails/sass-rails'
gem 'bourbon'
gem 'haml-rails', github: 'indirect/haml-rails' # 0.3.5 doesn't work with Rails 4

gem 'jquery-rails'
gem 'turbolinks'
gem 'simple_form'
gem 'pygments.rb'
gem 'redcarpet'
gem 'omniauth'
gem 'omniauth-google-oauth2'
gem 'draper'
gem 'rails_tokeninput'
gem 'momentjs-rails', github: 'olivierlacan/momentjs-rails'
gem 'textacular', require: 'textacular/rails'

group :development do
  gem 'guard'
  gem 'guard-rspec'
  gem 'guard-spork'
  gem 'rb-fsevent'
  gem 'fuubar'
  gem 'ruby_gntp'
  gem 'better_errors'
  gem 'binding_of_caller'
end

group :development, :test do
  gem 'rspec-rails', '~> 2.13.0'
  gem 'factory_girl_rails', '~> 4.2.1'
  gem 'pry-rails'
  gem 'pry-debugger'
  gem 'pry-remote'
end

group :test do
  gem 'shoulda-matchers', path: "~/Development/opensource/shoulda-matchers", branch: "rails4" # '~> 1.5.6'
  gem 'capybara', github: "jnicklas/capybara", branch: "master"
  gem 'coveralls', require: false
end