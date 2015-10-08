class AuthorDecorator < UserDecorator
  decorates :user

  def email
    if source.email && !source.private_email
      mail_to source.email
    end
  end

  def toggle_email_privacy
    alternate_email_status = source.private_email == true ? "Public" : "Private"
    link_to "Make Email #{alternate_email_status}", author_toggle_email_privacy_path(source), method: :put
  end
end
