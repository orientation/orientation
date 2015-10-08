OmniAuth.config.logger = Rails.logger

# Options for google oauth
Orientation::Application.config.x.oauth_options = {
 prompt: "select_account",
 image_aspect_ratio: "square",
 # we're displaying at 80 pixels, this is for high density ("Retina") displays
 image_size: 160,
 hd: ENV["ORIENTATION_EMAIL_WHITELIST"] || ""
}

# Other possible options when using an other oauth provider
# Orientation::Application.config.x.oauth_options = {
#   client_options: {
#     site: ENV['OAUTH_PROVIDER_URL']
#   }
# }

Rails.application.config.middleware.use OmniAuth::Builder do
  provider ENV['OAUTH_PROVIDER_NAME'], ENV['OAUTH_PROVIDER_KEY'], ENV['OAUTH_PROVIDER_SECRET'], Rails.configuration.x.oauth_options
end
