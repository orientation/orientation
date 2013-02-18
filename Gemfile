source 'https://rubygems.org'

ruby '1.9.3'

gem 'rails',     github: 'rails/rails'
gem 'journey',   github: 'rails/journey'
gem 'arel',      github: 'rails/arel'
gem 'activerecord-deprecated_finders', github: 'rails/activerecord-deprecated_finders'

gem 'pg'

group :assets do
  gem 'sprockets-rails', github: 'rails/sprockets-rails'
  gem 'sass-rails', '~> 4.0.0.beta', github: 'rails/sass-rails'
  gem 'coffee-rails', '~> 4.0.0.beta', github: 'rails/coffee-rails'

  gem 'uglifier', '>= 1.0.3'
end

# Heroku precompile fun
gem 'sass-rails', '~> 4.0.0.beta', github: 'rails/sass-rails'
gem 'coffee-rails', '~> 4.0.0.beta', github: 'rails/coffee-rails'
gem 'sprockets-rails', github: 'rails/sprockets-rails'
gem 'bourbon'
gem 'uglifier', '>= 1.0.3'
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
gem 'texticle', github: "olivierlacan/texticle", branch: "rails4"

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
