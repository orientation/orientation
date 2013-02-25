class AuthorDecorator < ApplicationDecorator
  delegate_all
  
  def email
    source.try(:email) || "No Email"
  end

  def name
    source.try(:name) || "Anonymous"
  end

  def image
    source.try(:image) || "https://secure.gravatar.com/avatar/1c02274fedcce55a289172bfb8db25ab.jpg"
  end
end
