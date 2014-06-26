class AuthorDecorator < ApplicationDecorator
  decorates :user
  
  delegate_all
  
  def email
    source.try :email || "No Email"
  end

  def name
    source.try :name || "Anonymous"
  end

  def image
    source.avatar.thumb.url or
    source.try :image
  end

  def image_link
    link_to image_tag(image, class: 'navatar'), author_path(source)
  end

  def email_tag
    mail_to email, email
  end

  def link_tag
    link_to name, author_path(source)
  end

  def status
    if source.active then "active" else "inactive" end
  end
end
