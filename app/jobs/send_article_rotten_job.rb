class SendArticleRottenJob < ActiveJob::Base
  queue_as :default

  def perform(article_id, contributors)
    article = Article.find(article_id)

    ArticleMailer.send_rotten_notification_for(article, contributors).deliver
  end
end
