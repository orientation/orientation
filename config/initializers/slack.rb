SLACK_CONFIG = if ENV["SLACK_WEBHOOK_URL"]
  Slack::Notifier.new ENV["SLACK_WEBHOOK_URL"],
  username: DEFAULT_FROM_NAME || 'Orientation',
  icon_emoji: ":book:"
else
  nil
end
