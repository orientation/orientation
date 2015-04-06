class Speakerphone
  def initialize(article, state, audience = $slack)
    @audience = audience
    @article = article
    @state = state
  end

  def shout
    if $slack.nil?
      Rails.logger.info { "ENV['SLACK_WEBHOOK_URL'] not configured, Speakerphone disabled." }
      return false
    end

    if @state == :created
      notify("New article", color: "good")
    elsif @state == :updated
      if @article.archived_at
        notify("Article archived", color: "#b1b3b4")
      elsif @article.rotted_at
        notify("Article rotten", color: "danger")
      else
        notify("Article updated", color: "warning")
      end
    elsif @state == :destroyed
      notify("Article destroyed", color: "danger")
    end
  end

  private

  def notify(title, color: "good")
    article = @article.to_speakerphone

    @audience.ping title,
    icon_emoji: ":book:",
    attachments: [{
      author_name: article.editor || article.author,
      title: article.title,
      title_link: url_for(article.slug),
      color: color
    }]
  end

  def url_for(slug)
    Rails.application.routes.url_helpers.article_url(slug, host: ENV.fetch("ORIENTATION_DOMAIN"))
  end
end
