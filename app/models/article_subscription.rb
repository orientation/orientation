class ArticleSubscription < ActiveRecord::Base
  belongs_to :article   
  belongs_to :user
  
  after_create :send_updates

  private

  def send_updates
    Delayed::Job.enqueue(SendArticleUpdateJob.new(article.id, user.id))
  end
end
