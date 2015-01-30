class ArticleEndorsement < ActiveRecord::Base
  belongs_to :article
  belongs_to :user

  def send_update
    Delayed::Job.enqueue(SendArticleUpdateJob.new(self.id, user.id))
  end


end
