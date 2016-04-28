module ApplicationHelper
  def body_class
    %|#{controller.controller_name} #{controller.controller_name}-#{controller.action_name} #{@body_class}|
  end

  def markdown(text)
    renderer = HtmlWithPygments.new(hard_wrap: true, escape_html: true)
    Redcarpet::Markdown.new(renderer, markdown_options.merge(footnotes: true)).render(text).html_safe
  end

  def table_of_contents(text)
    renderer = Redcarpet::Render::HTML_TOC.new(nesting_level: 4)
    Redcarpet::Markdown.new(renderer, markdown_options).render(text).html_safe
  end

  ##
  # Takes a time and a string to represent it. Outputs a proper <time>
  # element with a title tag that display the raw time.
  #
  def time_element(time, css_class = 'js-time')
    time = time.in_time_zone
    time_tag time, time.to_s(:long), title: time, class: css_class
  end

  ##
  # Just like time_element, but relative to now.
  #
  def relative_time_element(time)
    time_element(time, 'js-relative-time')
  end

  def page_title(title)
    content_for(:page_title, raw(title))
  end

  def current_action?(name, css)
    action_name == name ? css : ''
  end

  private

  def markdown_options
    {
      autolink: true,
      no_intra_emphasis: true,
      fenced_code_blocks: true,
      disable_indented_code_blocks: true,
      lax_spacing: true,
      lax_html_blocks: true,
      strikethrough: true,
      superscript: true,
      tables: true,
      with_toc_data: true
    }
  end
end
