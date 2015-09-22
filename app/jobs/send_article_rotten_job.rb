class SendArticleRottenJob < Struct.new(:article_id, :reporter_id)
  def perform
    article = Article.find(article_id)
    reporter = User.find(reporter_id)
    contributors = article.contributors
    ArticleMailer.send_rotten_notification_for(article, contributors, reporter).deliver
  end
end
