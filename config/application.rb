require File.expand_path('../boot', __FILE__)

# Pick the frameworks you want:
require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "sprockets/railtie"
# require "rails/test_unit/railtie"

# Assets should be precompiled for production (so we don't need the gems loaded then)
Bundler.require(*Rails.groups(assets: %w(development test)))

module Orientation
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Custom directories with classes and modules you want to be autoloadable.
    # config.autoload_paths += %W(#{config.root}/extras)

    # Configure sensitive parameters which will be filtered from the log file.
    config.filter_parameters += [:password]

    # Use SQL instead of Active Record's schema dumper when creating the database.
    # This is necessary if your schema can't be completely dumped by the schema dumper,
    # like if you have constraints or database-specific column types.
    config.active_record.schema_format = :sql

    # Enable the asset pipeline.
    config.assets.enabled = true

    # Version of your assets, change this if you want to expire all your assets.
    config.assets.version = '1.0'

    # Prevent Rails from initializing during the precompile phase on Heroku
    config.assets.initialize_on_precompile = false

    # prefer indented sass syntax
    config.sass.preferred_syntax = :sass

    config.generators do |g|
      g.test_framework :rspec
      g.view_specs false
      g.helper_specs false
    end
  end
end
