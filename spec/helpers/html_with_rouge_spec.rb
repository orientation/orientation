require "rails_helper"
require "rouge"

RSpec.describe HtmlWithRouge do
  describe "render" do
    let(:renderer) { described_class.new(hard_wrap: true, escape_html: true) }
    let(:options) { described_class.markdown_options }
    let(:result) do
      Redcarpet::Markdown.new(renderer, options.merge(footnotes: true)).render(text).html_safe
    end

    context "with [[reference links]]" do
      let(:text) { "[[hello]]" }

      it "turns them into proper links" do
        expect(result).to eq("<p><a href='/articles/hello'  class='article-not-found'>hello</a></p>\n")
      end
    end

    context "with [[reference|links]]" do
      let(:text) { "[[hello|motto]]" }

      it "turns them into proper links" do
        expect(result).to eq("<p><a href='/articles/motto'  class='article-not-found'>hello</a></p>\n")
      end
    end
  end
end
