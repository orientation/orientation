source "http://rubygems.org"

ruby '1.9.3'

gem 'rails',     github: 'rails/rails'
gem 'journey',   github: 'rails/journey'
gem 'arel',      github: 'rails/arel'
gem 'activerecord-deprecated_finders', github: 'rails/activerecord-deprecated_finders'

gem 'pg'

group :assets do
  gem 'sprockets-rails', github: 'rails/sprockets-rails'
  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  gem 'uglifier', '>= 1.0.3'
end

# Heroku precompile fun
gem 'sass-rails',   github: 'rails/sass-rails'
gem 'coffee-rails', github: 'rails/coffee-rails'
gem 'sprockets-rails', github: 'rails/sprockets-rails'
gem 'bourbon'
gem 'uglifier', '>= 1.0.3'
gem 'haml-rails'

gem 'jquery-rails'
gem 'turbolinks'
gem 'simple_form'

gem 'pygments.rb'
gem 'redcarpet'

gem 'omniauth'
gem 'omniauth-google-oauth2'

gem 'draper'

# Puts a simple HTTP cache in front of your app (and gets you ready for later upgrading to nginx/varnish/squid)
# gem 'rack-cache', '~> 1.2'

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# Build JSON APIs with ease. Read more: http://github.com/rails/jbuilder
# gem 'jbuilder'

# Use unicorn as the app server
# gem 'unicorn'

# To use debugger
group :development do
  gem 'guard'
  gem 'guard-rspec'
  gem 'guard-spork'
  gem 'rb-fsevent'
  gem 'fuubar'
  gem 'ruby_gntp'
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
