# -*- encoding : utf-8 -*-

if !Rails.env.test?
  require 'yaml'

  ActionMailer::Base.smtp_settings = {
    :address   => "smtp.mandrillapp.com",
    :port      => 587,
    :user_name => ENV.fetch("MANDRILL_USERNAME"),
    :password  => ENV.fetch("MANDRILL_API_KEY"),
    :domain    => ENV.fetch("MANDRILL_DOMAIN")
  }
  ActionMailer::Base.delivery_method = :smtp

  MandrillMailer.configure do |config|
    config.api_key = ENV.fetch("MANDRILL_API_KEY")
  end
end
