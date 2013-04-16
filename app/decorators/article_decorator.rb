class ArticleDecorator < ApplicationDecorator
  delegate_all

  def authors
    output = "by #{author_email_tag} on #{created_at_tag} "

    if editor && updated_at_tag
      if editor.id != source.author_id
        output << "and updated by #{editor_email_tag} on #{updated_at_tag}"
      else
        output << "and updated on #{updated_at_tag}"
      end
    end

    output.html_safe
  end

  def title
    source.try(:title) || "No title"
  end

  def created_at_tag
    time_element(source.created_at.in_time_zone)
  end

  def updated_at_tag
    time_element(source.updated_at.in_time_zone)
  end
  
  def author
    AuthorDecorator.new(source.author)
  end

  def author_email_tag
    mail_to author.email, author.name
  end

  def editor
    AuthorDecorator.new(source.editor) if source.editor
  end

  def editor_email_tag
    mail_to source.try(:editor).try(:email), source.try(:editor).try(:name)
  end

  def freshness
    content_tag(:span, "fresh", class: "fresh") if source.fresh?
  end
end
