module ApplicationHelper
  def body_class
    %|#{controller.controller_name} #{controller.controller_name}-#{controller.action_name} #{@body_class}|
  end

  class HTMLwithPygments < Redcarpet::Render::HTML
    def block_code(code, language)
      sha = Digest::SHA1.hexdigest(code)
      Rails.cache.fetch ["code", language, sha].join('-') do
        add_line_numbers(Pygments.highlight(code, lexer: language))
      end
    end

    def add_line_numbers(code)
      current_line = 0
      code_arr = code.split("\n")
      line_numbers = []
      (code_arr.length - 1).times do |n|
        current_line += 1
        line_numbers << "<span>#{current_line}: </span>"
      end
      line_numbers_div = <<-HTML.strip_heredoc
        <div class='line-numbers'>
          #{line_numbers.join("<br />")}<br />
        </div>
      HTML

      markdown_div = <<-HTML.strip_heredoc
        <div class='code-block'>
          #{line_numbers_div} 
          #{code}
        </div>
      HTML
    end
  end

  def markdown(text)
    renderer = HTMLwithPygments.new(hard_wrap: true, filter_html: false)
    options = {
      autolink: true,
      no_intra_emphasis: true,
      fenced_code_blocks: true,
      lax_spacing: true,
      lax_html_blocks: true,
      strikethrough: true,
      superscript: true
    }
    Redcarpet::Markdown.new(renderer, options).render(text).html_safe
  end
end