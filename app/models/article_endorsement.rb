class ArticleEndorsement < ActiveRecord::Base
  include Dateable

  belongs_to :article
  belongs_to :user

  after_create :send_endorsement

  def send_endorsement
    Delayed::Job.enqueue(SendArticleEndorsementJob.new(self.id))
  end
end
