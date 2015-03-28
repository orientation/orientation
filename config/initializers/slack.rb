$slack = Slack::Notifier.new ENV["SLACK_WEBHOOK_URL"],
  username: "Orientation",
  icon_emoji: ":book:"
