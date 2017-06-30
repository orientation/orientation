require_relative 'boot'

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
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

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
    #   Rails.configuration.orientation["transactional_mailer"] = :mandrill
    # And you can read those same values with:
    #   Rails.configuration.orientation["transactional_mailer"]
    #
    config.orientation = config_for(:orientation)
  end
end
