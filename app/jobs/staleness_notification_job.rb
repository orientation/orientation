class StalenessNotificationJob < Struct.new(:articles)
  def perform
    articles.map do |article|
      article.update_column(:last_notified_author_at, Date.today)
    end
    ArticleMailer.notify_author_of_staleness(articles).deliver
  end
end