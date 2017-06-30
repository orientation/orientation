class ArticleEndorsement < ApplicationRecord
  include Dateable

  belongs_to :article, counter_cache: :endorsements_count
  belongs_to :user

  after_create :send_endorsement

  validates :article_id, uniqueness: {
    scope: :user_id, message: "already exists for user"
  }

  def send_endorsement
    SendArticleEndorsementJob.perform_later(id)
  end
end
