class ArticleSubscription < ActiveRecord::Base
  belongs_to :article   
  belongs_to :user

  def send_update_for(article_id)
    Delayed::Job.enqueue(SendArticleUpdateJob.new(article_id, user.id))
  end
end
