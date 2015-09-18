OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2, ENV['GOOGLE_KEY'], ENV['GOOGLE_SECRET'],
  {
    prompt: "select_account",
    image_aspect_ratio: "square",
    # we're displaying at 80 pixels, this is for high density ("Retina") displays
    image_size: 160,
    hd: ENV["ORIENTATION_EMAIL_WHITELIST"] || ""
  }

  provider :github, ENV["GITHUB_CLIENT_ID"], ENV["GITHUB_SECRET"],
           scope: "user:email",
           client_options: {
             site: ENV['GITHUB_URL']
           }

  provider :gitlab, ENV["GITLAB_KEY"], ENV["GITLAB_SECRET"],
           client_options: {
             site: ENV['GITLAB_URL']
           }
end
