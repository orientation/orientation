class StalenessNotificationJob < ApplicationJob
  queue_as :default

  def perform(article_ids)
    # Disable until preferences can be implemented.
    #
    # articles = Article.find(article_ids)
    # articles.each do |article|
    #   article.update_column(:last_notified_author_at, Date.today)
    # end
    # ArticleMailer.notify_author_of_staleness(articles).deliver
  end
end
