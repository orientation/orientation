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

    it "converts emoji markdown to HTML" do
      article.update!(content: "This is a :octocat: emoji")
      expect(markdown(article.content)).to include("<img alt=\"octocat\" src=\"/images/emoji/octocat.png\" style=\"vertical-align:middle\" width=\"20\" height=\"20\" />")
    end

    it "does not convert emoji markdown inside fenced code blocks" do
      article.update!(content: "This should not convert ``` :octocat: ```.")
      expect(markdown(article.content)).to include(":octocat")
    end

    it "does not convert emoji markdown inside inline code" do
      article.update!(content: "This `ocf:heartbeat:ip` emoji should not be converted.")
      expect(markdown(article.content)).to include(":heartbeat:")
    end

    it "converts emoji markdown but does not convert emoji markdown in both fenced and inline" do
      article.update!(content: "This ocf:heartbeat:ip should convert, however, this `ocf:heartbeat:ip` emoji should not be converted and neither should this ```ocf:hearthbeat:ip```")
      expect(markdown(article.content)).to include("<p>This ocf<img alt="heartbeat" src="/images/emoji/unicode/1f493.png" style="vertical-align:middle" width="20" height="20" />ip should convert, however, this <code>ocf:heartbeat:ip</code> emoji should not be converted and neither should this <code>ocf:hearthbeat:ip</code></p>")
    end
  end
end
