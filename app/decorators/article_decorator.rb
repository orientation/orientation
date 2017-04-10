class ArticleDecorator < ApplicationDecorator
  delegate_all

  def authors
    output = [author.link_tag, created_at_tag]

    if editor && updated_at_tag
      output << "and updated"
      output << "by #{editor_email_tag}" if editor.id != object.author_id
      output << "on #{updated_at_tag}"
    end

    output.join(" ").html_safe
  end

  def title
    object.try(:title) || "No title"
  end

  def created_at_tag
    time_element(object.created_at)
  end

  def updated_at_tag
    time_element(object.updated_at)
  end

  def author
    AuthorDecorator.new(object.author)
  end

  def editor
    AuthorDecorator.new(object.editor) if object.editor
  end

  def editor_email_tag
    mail_to object.try(:editor).try(:email), object.try(:editor).try(:name)
  end

  def freshness
    content_tag(:span, "fresh", class: "state fresh") if object.fresh?
  end

  def staleness
    content_tag(:span, "stale", class: "state stale") if object.stale?
  end

  def outdatedness
    content_tag(:span, "outdated", class: "state outdated") if object.outdated?
  end

  def outdatedness_reporter(viewing_user = nil)
    if object.outdatedness_reporter
      if viewing_user == object.outdatedness_reporter
        link_to "You", author_url(object.outdatedness_reporter)
      else
        link_to AuthorDecorator.new(object.outdatedness_reporter), author_url(object.outdatedness_reporter)
      end
    end
  end

  def outdated_at
    object.outdated_at.to_date.to_s(:long_ordinal)
  end

  def signal
    state = :fresh if object.fresh?
    state = :stale if object.stale?
    state = :outdated if object.outdated?

    screen_reader_text = content_tag(:span, state, class: 'srt')

    if state
      content_tag(:div, screen_reader_text, class: "signal signal--#{state}")
    else
      content_tag(:div, state, class: 'signal')
    end
  end
end
