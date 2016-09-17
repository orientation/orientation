if Rails.configuration.orientation["exception_reporting"] == :bugsnag
  require "bugsnag"

  Bugsnag.configure do |config|
    # the API key is set with the BUGSNAG_API_KEY environment variable but you
    # can also hardcode it here with the following configuration variable:
    #   config.api_key = "NOPE"
    config.notify_release_stages = ["production"]
  end
end
