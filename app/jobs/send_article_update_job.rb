class SendArticleUpdateJob < ActiveJob::Base
  queue_as :default

  def perform(article_id, user_id)
    article = Article.find(article_id)
    user    = User.find(user_id)

    ArticleMailer.send_updates_for(article, user).deliver
    article.update_attribute(:change_last_communicated_at, Time.zone.now)
  end
end
