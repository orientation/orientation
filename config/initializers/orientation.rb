# We use Rails.configuration.orientation to load environment-specific
# configuration values from config/orientation.yml
#
# You can find example values in config/orientation.yml.sample
#
# Once the application has booted you can assign values directly on the
# Orientation::Configuration interface like this:
#   Orientation::Configuration["mailers"] = :mandrill
module Orientation
  Configuration = Rails.configuration.orientation
end
