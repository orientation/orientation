class SendArticleRottenJob < Struct.new(:article_id, :contributors)
  def perform
    article = Article.find(article_id)
    ArticleMailer.send_rotten_notification_for(article, contributors).deliver
  end
end
