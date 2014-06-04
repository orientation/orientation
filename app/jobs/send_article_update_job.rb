class SendArticleUpdateJob < Struct.new(:article_id, :user_id)
  def perform
    article = Article.find(article_id)
    user = User.find(user_id)

    ArticleMailer.send_updates_for(article, user).deliver
  end
end
