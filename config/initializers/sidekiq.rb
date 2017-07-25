require 'sidekiq/web'

Sidekiq.default_worker_options = { 'backtrace' => true }

if Rails.env.production?
  Sidekiq::Web.use Rack::Auth::Basic do |username, password|
    username == ENV["SIDEKIQ_USERNAME"] && password == ENV["SIDEKIQ_PASSWORD"]
  end
end
