class UserDecorator < ApplicationDecorator
  delegate_all

  def email
    source.try :email || "No Email"
  end

  def email_tag
    mail_to email, "Get in touch with #{first_name}"
  end

  def first_name
    source.name.split(" ").first
  end

  def image
    source.try(:image) or asset_path("default_avatar.jpg")
  end

  def image_link(size = 40)
    link_to image_tag(image, class: 'thumb dib', height: size, width: size), author_path(source)
  end

  def link
    author_path(source)
  end

  def link_tag
    link_to name, author_path(source)
  end

  def name
    source.try :name || "Anonymous"
  end

  def status
    if source.active then "active" else "inactive" end
  end
end
