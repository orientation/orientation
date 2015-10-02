class Speakerphone
  attr_reader :audience, :state, :article

  def initialize(article, state, audience = SLACK_CONFIG)
    @audience = audience
    @article = article
    @state = state
  end

  def should_shout?
    !audience.nil?
  end

  def issue_warning
    Rails.logger.info do
      "ENV['SLACK_WEBHOOK_URL'] not configured, Speakerphone disabled."
    end
  end

  def shout
    unless should_shout?
      issue_warning
      return false
    end

    ping_audience(notifications)
  end

  delegate :author, :title, :slug, to: :article
  def speakerphone
    @speakerphone ||= begin
      { author: author.name, title: title, slug: slug }.with_indifferent_access
    end
  end

  def ping_audience(title: , color: "good")
    audience.ping title,
    icon_emoji: ":book:",
    attachments: [{
      author_name: speakerphone[:editor] || speakerphone[:author],
      title:       speakerphone[:title],
      title_link:  url_for(slug),
      color: color
    }]
  end

  private

  def notifications
    notifications = {
      created:   { title: 'New article', color: 'good' },
      archived:  { title: 'Article archived', color: '#b1b3b4' },
      rotten:    { title: 'Article rotten', color: 'danger' },
      updated:   { title: 'Article updated', color: 'warning' },
      destroyed: { title: 'Article destroyed', color: 'danger' }
    }

    notifications[state]
  end

  def url_for(slug)
    Rails.application.routes.url_helpers.article_url(slug, host: ENV.fetch("ORIENTATION_DOMAIN"))
  end
end
