require "rails_helper"

RSpec.describe ApplicationHelper do
  include ApplicationHelper

  describe "#markdown(text)" do
    let(:article) { create(:article) }

    it "converts the explicit markdown link to HTML" do
      article.update!(content: "[link](http://example.org)")
      expect(markdown(article.content)).to include("<a href='http://example.org'>link</a>")
    end

    it "converts the implicit markdown slug link (to an invalid article) to HTML" do
      article.update!(content: "[[link]]")
      expect(markdown(article.content)).to include("<a href='/articles/link'  class='article-not-found'>link</a>")
    end

    it "converts the implicit markdown slug link (to an invalid article) in a list item to HTML" do
      article.update!(content: "- [[link]]")
      expect(markdown(article.content)).to include("<a href='/articles/link'  class='article-not-found'>link</a>")
    end

    it "converts the implicit markdown slug link (to a valid article) to HTML" do
      article.update!(title: "link", content: "[[link]]")
      expect(markdown(article.content)).to include("<a href='/articles/link'>link</a>")
    end

    it "converts the implicit markdown title link (to a valid article) to HTML" do
      article.update!(title: "This is a title", content: "[[This is a title]]")
      expect(markdown(article.content)).to include("<a href='/articles/this-is-a-title'>This is a title</a>")
    end
  end
end
