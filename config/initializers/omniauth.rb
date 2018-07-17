OmniAuth.config.logger = Rails.logger

orientation_config = Rails.configuration.orientation
oauth_provider_name   = orientation_config['oauth_provider_name']
oauth_provider_key    = orientation_config['oauth_provider_key'] || ENV['GOOGLE_KEY']
oauth_provider_secret = orientation_config['oauth_provider_secret'] || ENV['GOOGLE_SECRET']

oauth_options = {}

if oauth_provider_name && oauth_provider_name.to_sym == :google_oauth2
  oauth_options = {
    prompt: "select_account",
    image_aspect_ratio: "square",
    # we're displaying at 80 pixels, this is for high density ("Retina") displays
    image_size: 160,
    # hd means hosted domain and this option allows limiting to a particular
    # Google Apps hosted domain. More information at:
    #   https://developers.google.com/accounts/docs/OpenIDConnect#hd-param
    hd: ENV["ORIENTATION_EMAIL_WHITELIST"] && ENV["ORIENTATION_EMAIL_WHITELIST"].split(":")
  }
end

Rails.application.config.middleware.use OmniAuth::Builder do
  provider oauth_provider_name, oauth_provider_key, oauth_provider_secret, oauth_options
end
