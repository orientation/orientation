class ArticleSubscriptionDecorator < ApplicationDecorator
  delegate_all

  def created_at
    source.created_at.to_formatted_s(:long)
  end

  def user
    source.user.decorate
  end
end
