class SendArticleUpdateJob < ApplicationJob
  queue_as :default

  def perform(article_id, user_id)
    article = Article.find(article_id)
    user = User.find(user_id)

    ArticleMailer.send_updates_for(article, user).deliver
  end
end
