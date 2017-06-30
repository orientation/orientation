SLACK_CONFIG = if ENV["SLACK_WEBHOOK_URL"]
  notifier = Slack::Notifier.new ENV["SLACK_WEBHOOK_URL"] do
    defaults  username: ENV['DEFAULT_FROM_NAME'] || 'Orientation',
              icon_emoji: ":book:"
  end
else
  nil
end
