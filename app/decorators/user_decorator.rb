class UserDecorator < ApplicationDecorator
  delegate_all

  def email
    object.try :email || "No Email"
  end

  def email_tag
    mail_to email, "Get in touch with #{first_name}"
  end

  def first_name
    object.name.split(" ").first
  end

  def image
    object.try(:image) or asset_path("default_avatar.jpg")
  end

  def image_link(size = 40)
    link_to image_tag(image, class: 'thumb dib', height: size, width: size), author_path(object)
  end

  def link
    author_path(object)
  end

  def link_tag
    link_to name, author_path(object)
  end

  def name
    object.try :name || "Anonymous"
  end

  def status
    if object.active then "active" else "inactive" end
  end
end
