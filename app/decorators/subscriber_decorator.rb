class SubscriberDecorator < ApplicationDecorator
  decorates :user

  delegate_all

  def subscription_date(article)
    article.subscriptions.find_by(user_id: object.id).created_at
  end
end
