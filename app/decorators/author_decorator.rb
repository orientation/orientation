class AuthorDecorator < ApplicationDecorator
  delegate_all
  
  def email
    source.try :email || "No Email"
  end

  def name
    source.try :name || "Anonymous"
  end

  def image
    source.avatar.thumb.url or
    source.try :image or
    "https://secure.gravatar.com/avatar/1c02274fedcce55a289172bfb8db25ab.jpg"
  end

  def email_tag
    mail_to email, email
  end

  def link_tag
    link_to name, author_path(source)
  end
end
