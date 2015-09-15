module ApplicationHelper
  def body_class
    %|#{controller.controller_name} #{controller.controller_name}-#{controller.action_name} #{@body_class}|
  end

  class HTMLwithPygments < Redcarpet::Render::HTML
    def header(title, level)
      permalink = title.gsub(/\W+/, '-').downcase
      %(
          <a id='#{permalink}' class='heading js-headingLink' href='##{permalink}'>
            <input class='heading-link js-headingLink-link' value='##{permalink}' readonly>
            <h#{level} class='heading-text js-headingLink-heading'>#{title}</h#{level}>
          </a>
      )
    end

    def block_code(code, language)
      safe_language = Pygments::Lexer.find_by_alias(language) ? language : nil

      sha = Digest::SHA1.hexdigest(code)
      Rails.cache.fetch ["code", safe_language, sha].join('-') do
        Pygments.highlight(code, lexer: safe_language)
      end
    end

    def link(link, title, content)
      if internal_link?(link) && !valid_article?(link)
        class_attribute = "class='#{article_status(link)}'"
      end
      title_attribute = "title='#{title}'" if title

      if class_attribute || title_attribute
        "<a href='#{link}' #{title_attribute} #{class_attribute}>#{content}</a>"
      else
        # Redcarpet doesn't allow calls to super in overidden
        # render methods due to C shenanigans:
        # https://github.com/vmg/redcarpet/issues/51#issuecomment-1922079
        "<a href='#{link}'>#{content}</a>"
      end
    end

    def normal_text(text)
      text.gsub!("[ ]", "<input type='checkbox'>") if text.match(/^\[{1}\s\]{1}/)
      text.gsub!("[x]", "<input type='checkbox' checked>") if text.match(/^\[{1}(x|X)\]{1}/)

      text
    end

    def preprocess(full_document)
      # matches [[Article Title]] or [[article-title]] relative
      # links, see https://regex101.com/r/aR5bS0/1
      pattern = /\[{2}(.*?)\]{2}/

      if full_document.match(pattern)
        full_document.gsub!(pattern) do |match|
          text = match.delete("[[]]")
          "[#{text}](#{article_link(text.parameterize)})"
        end
      else
        full_document
      end
    end

    private

    def article_status(link)
      'article-not-found' if !valid_article?(link)
    end

    def article_link(article_title)
      Rails.application.routes.url_helpers.article_url(article_title, only_path: true)
    end

    def internal_link?(link)
      url = URI.parse(link)

      if url.absolute?
        root = Rails.application.routes.url_helpers.root_url(host: ENV.fetch("ORIENTATION_DOMAIN"))
        link.include?(root)
      else
        true
      end
    end

    def valid_article?(link)
      link = URI.parse(link).path if !internal_link?(link)
      slug = link.split('/').last

      Article.friendly.find(slug)
    rescue ActiveRecord::RecordNotFound
      false
    end
  end

  def emojify(content)
    content.gsub(/:([\w+-]+):/) do |match|
      if emoji = Emoji.find_by_alias($1)
        %(<img alt="#$1" src="/images/emoji/#{emoji.image_filename}" style="vertical-align:middle" width="20" height="20" />)
      else
        match
      end
    end.html_safe
  end

  def markdown(text)
    renderer = HTMLwithPygments.new(hard_wrap: true, filter_html: false)
    text = emojify(text)
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
