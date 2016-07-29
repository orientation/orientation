class RottenNotificationJob < ActiveJob::Base
  queue_as :default

  def perform(article_ids)
    articles = Article.find(article_ids)
    articles.each do |article|
      article.update_column(:last_notified_author_at, Date.today)
    end

    ArticleMailer.notify_author_of_rotten(articles).deliver
  end
end
