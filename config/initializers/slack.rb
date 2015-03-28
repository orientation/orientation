if ENV["SLACK_WEBHOOK_URL"]
  $slack = Slack::Notifier.new ENV["SLACK_WEBHOOK_URL"],
  username: "Orientation",
  icon_emoji: ":book:"
else
  $slack = nil
end
