class SendArticleRottenJob < ApplicationJob
  queue_as :default

  def perform(article_id, reporter_id)
    article = Article.find(article_id)
    contributors = article.contributors
    reporter = User.find(reporter_id)

    ArticleMailer.send_rotten_notification_for(article, contributors, reporter).deliver
  end
end
