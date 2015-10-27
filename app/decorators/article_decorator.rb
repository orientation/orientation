class ArticleDecorator < ApplicationDecorator
  delegate_all

  def authors
    output = [author.link_tag, created_at_tag]

    if editor && updated_at_tag
      output << "and updated"
      output << "by #{editor_email_tag}" if editor.id != source.author_id
      output << "on #{updated_at_tag}"
    end

    output.join(" ").html_safe
  end

  def title
    source.try(:title) || "No title"
  end

  def created_at_tag
    time_element(source.created_at)
  end

  def updated_at_tag
    time_element(source.updated_at)
  end

  def author
    AuthorDecorator.new(source.author)
  end

  def editor
    AuthorDecorator.new(source.editor) if source.editor
  end

  def editor_email_tag
    mail_to source.try(:editor).try(:email), source.try(:editor).try(:name)
  end

  def freshness
    content_tag(:span, "fresh", class: "state fresh") if source.fresh?
  end

  def staleness
    content_tag(:span, "stale", class: "state stale") if source.stale?
  end

  def rottenness
    content_tag(:span, "rotten", class: "state rotten") if source.rotten?
  end

  def rot_reporter
    if source.rot_reporter
      link_to AuthorDecorator.new(source.rot_reporter), author_url(source.author)
    end
  end

  def rotted_at
    source.rotted_at.to_date.to_s(:long_ordinal)
  end

  def signal
    state = 'fresh' if source.fresh?
    state = 'stale' if source.stale?
    state = 'rotten' if source.rotten?

    screen_reader_text = content_tag(:span, state, class: 'srt')

    if state
      content_tag(:div, screen_reader_text, class: "signal signal--#{state}")
    else
      content_tag(:div, state, class: 'signal')
    end
  end
end
