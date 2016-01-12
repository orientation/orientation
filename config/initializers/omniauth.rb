OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2, ENV['GOOGLE_KEY'], ENV['GOOGLE_SECRET'],
  {
    prompt: "select_account",
    image_aspect_ratio: "square",
    # we're displaying at 80 pixels, this is for high density ("Retina") displays
    image_size: 160,
    hd: ENV.fetch("ORIENTATION_EMAIL_WHITELIST")
  }
end
