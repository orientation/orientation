SLACK_CONFIG = if ENV["SLACK_WEBHOOK_URL"]
  Slack::Notifier.new ENV["SLACK_WEBHOOK_URL"],
  username: "Orientation",
  icon_emoji: ":book:"
else
  nil
end
