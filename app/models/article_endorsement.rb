class ArticleEndorsement < ApplicationRecord
  include Dateable

  belongs_to :article, counter_cache: :endorsements_count
  belongs_to :user

  after_create :send_endorsement

  def send_endorsement
    SendArticleEndorsementJob.perform_later(id)
  end
end
