class AuthorDecorator < UserDecorator
  decorates :user

  def email
    if object.email && !object.private_email
      mail_to object.email
    end
  end

  def toggle_email_privacy
    alternate_email_status = object.private_email == true ? "Public" : "Private"
    link_to "Make Email #{alternate_email_status}", author_toggle_email_privacy_path(object), method: :put
  end
end
