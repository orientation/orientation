class ArticleSubscriptionDecorator < ApplicationDecorator
  delegate_all

  def created_at
    object.created_at.to_formatted_s(:long)
  end
end
