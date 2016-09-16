require File.expand_path('../boot', __FILE__)

# Pick the frameworks you want:
require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "sprockets/railtie"
# require "rails/test_unit/railtie"
require "action_cable/engine"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Orientation
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Use SQL instead of Active Record's schema dumper when creating the database.
    # This is necessary if your schema can't be completely dumped by the schema dumper,
    # like if you have constraints or database-specific column types.
    config.active_record.schema_format = :sql

    # prefer indented sass syntax
    config.sass.preferred_syntax = :sass

    # https://robots.thoughtbot.com/content-compression-with-rack-deflater
    config.middleware.use Rack::Deflater

    config.generators do |g|
      g.test_framework :rspec
      g.view_specs false
      g.helper_specs false
    end

    config.active_job.queue_adapter = :delayed_job

    # We load environment-specific configuration values from 
    # config/orientation.yml into Rails.configuration.orientation
    #
    # You can find example values in config/orientation.example.yml
    #
    # Once the application has booted you can assign values directly like this:
    #   Rails.configuration.orientation["mailers"] = :mandrill
    # And you can read those same values with:
    #   Rails.configuration.orientation["mailers"]
    #
    config.orientation = config_for(:orientation)
  end
end
