# -*- encoding : utf-8 -*-
require 'yaml'

begin
  options = YAML.load_file(Rails.root.join('config', 'mandrill.yml'))[Rails.env]

  ActionMailer::Base.smtp_settings = {
    :address   => "smtp.mandrillapp.com",
    :port      => 587,
    :user_name => options['username'],
    :password  => options['password'],
    :domain    => 'heroku.com'
  }
  ActionMailer::Base.delivery_method = :smtp

  MandrillMailer.configure do |config|
    config.api_key = options['api_key']
  end
rescue LoadError
  puts "The Mandrill configuration (config/mandrill.yml) is missing or malformed"
  exit(1)
end
