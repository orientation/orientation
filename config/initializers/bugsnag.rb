Bugsnag.configure do |config|
  # the API key is set with the BUGSNAG_API_KEY environment variable
  # config.api_key = "NOPE"
  config.notify_release_stages = ["production"]
end
