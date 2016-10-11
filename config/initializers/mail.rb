if !Rails.env.test?
  def mandrill_configured?
    ENV["MANDRILL_USERNAME"].present? && 
    ENV["MANDRILL_API_KEY"].present? &&
    ENV["MANDRILL_DOMAIN"].present?
  end

  if mandrill_configured?
    require 'yaml'

    ActionMailer::Base.smtp_settings = {
      address:   "smtp.mandrillapp.com",
      port:      587,
      user_name: ENV["MANDRILL_USERNAME"],
      password:  ENV["MANDRILL_API_KEY"],
      domain:    ENV["MANDRILL_DOMAIN"]
    }
    ActionMailer::Base.delivery_method = :smtp

    MandrillMailer.configure do |config|
      config.api_key = ENV["MANDRILL_API_KEY"]
    end
  else
    Rails.logger.info { "Mandrill environment variables not set. Transactional emails will not be sent."}
  end
end
