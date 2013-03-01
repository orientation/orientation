source 'https://rubygems.org'

ruby '1.9.3'

gem 'rails', '~> 4.0.0.beta1', github: 'rails/rails'

gem 'pg'
gem 'thin'

group :assets do
  gem 'sprockets-rails', github: 'rails/sprockets-rails'
  gem 'sass-rails', github: 'rails/sass-rails'
  gem 'coffee-rails', github: 'rails/coffee-rails'

  gem 'uglifier', '>= 1.0.3'
end

# Heroku precompile fun
gem 'bourbon'
gem 'haml-rails', github: "indirect/haml-rails" # 0.3.5 doesn't work with Rails 4

gem 'jquery-rails'
gem 'turbolinks'
gem 'simple_form'
gem 'pygments.rb'
gem 'redcarpet'
gem 'omniauth'
gem 'omniauth-google-oauth2'
gem 'draper'
gem 'rails_tokeninput'
gem 'momentjs-rails', github: "olivierlacan/momentjs-rails"
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
  gem 'rspec-rails'
  gem 'pry-rails'
  gem 'pry-debugger'
  gem 'pry-remote'
end

group :test do
  gem 'shoulda-matchers'
end
