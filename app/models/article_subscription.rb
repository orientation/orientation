class ArticleSubscription < ApplicationRecord
  include Dateable

  belongs_to :article, counter_cache: :subscriptions_count
  belongs_to :user

  validates :user_id, uniqueness: {
    scope: :article_id, message: "is already subscribed"
  }

  def send_update
    ArticleUpdatedWorker.perform_in(5.minutes, article.id, user.id)
  end

  def subscriber
    user
  end
end
