class AuthorDecorator < ApplicationDecorator
  delegate_all
  
  def email
    source.try(:email) || "No Email"
  end

  def name
    source.try(:name) || "Anonymous"
  end
end
