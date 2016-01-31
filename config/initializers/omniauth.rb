OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2, ENV['GOOGLE_KEY'], ENV['GOOGLE_SECRET'],
  {
    prompt: "select_account",
    image_aspect_ratio: "square",
    # we're displaying at 80 pixels, this is for high density ("Retina") displays
    image_size: 160,
    # hd means hosted domain and this option allows limiting to a particular
    # Google Apps hosted domain. More information at:
    #   https://developers.google.com/accounts/docs/OpenIDConnect#hd-param
    hd: ENV.fetch("ORIENTATION_EMAIL_WHITELIST") do |element|
      if Rails.env.production?
        raise "ORIENTATION_EMAIL_WHITELIST is not set"
      else
        # we don't care if no ORIENTATION_EMAIL_WHITELIST is set in non-production environments
        nil
      end
    end
  }

  provider :github, ENV['GITHUB_CLIENT_ID'], ENV['GITHUB_SECRET'],
           scope: 'user:email',
           client_options: {
             site: ENV['GITHUB_URL']
           }

  provider :gitlab, ENV['GITLAB_APPLICATION_ID'], ENV['GITLAB_SECRET'],
           client_options: {
             site: ENV['GITLAB_URL']
           }
end
