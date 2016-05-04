class ArticleEndorsementDecorator < ApplicationDecorator
  delegate_all

  def created_at
    object.created_at.to_formatted_s(:long)
  end

  def user
    object.user.decorate
  end
end
