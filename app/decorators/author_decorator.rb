class AuthorDecorator < ApplicationDecorator
  delegate_all
  
  def email
    source.email || "No Email"
  end

  def name
    source.name || "Anonymous"
  end

  def image
    source.image || "https://secure.gravatar.com/avatar/1c02274fedcce55a289172bfb8db25ab.jpg"
  end

  def to_s
    source.to_s
  end
end
