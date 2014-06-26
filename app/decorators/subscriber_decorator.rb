class SubscriberDecorator < ApplicationDecorator
  decorates :user

  delegate_all

  def subscription_date(article)
    article.article_subscriptions.find_by(user_id: user.id).created_at
  end
end
