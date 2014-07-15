module ApplicationHelper
  def body_class
    %|#{controller.controller_name} #{controller.controller_name}-#{controller.action_name} #{@body_class}|
  end

  class HTMLwithPygments < Redcarpet::Render::HTML
    def header(title, level)
      @headers ||= []
      permalink = title.gsub(/\W+/, '-').downcase

      if @headers.include? permalink
        permalink += '_1'
        permalink = permalink.succ while @headers.include? permalink
      end
      @headers << permalink
      %(
        <h#{level} id=\"#{permalink}\"><a name="#{permalink}" class="anchor" href="##{permalink}"></a>#{title}</h#{level}>
      )
    end

    def block_code(code, language)
      safe_language = Pygments::Lexer.find_by_alias(language) ? language : nil

      sha = Digest::SHA1.hexdigest(code)
      Rails.cache.fetch ["code", safe_language, sha].join('-') do
        Pygments.highlight(code, lexer: safe_language)
      end
    end
  end

  def markdown(text)
    renderer = HTMLwithPygments.new(hard_wrap: true, filter_html: false)
    options = {
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
    Redcarpet::Markdown.new(renderer, options).render(text).html_safe
  end

  ##
  # Takes a time and a string to represent it. Outputs a proper <time>
  # element with a title tag that display the raw time.
  #
  def time_element(time)
    time_tag time, time.to_s(:long), title: time
  end

  def page_title(title)
    content_for(:page_title, raw(title))
  end
end
