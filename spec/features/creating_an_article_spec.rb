require "rails_helper"

RSpec.describe 'Creating an article' do
  before { visit new_article_path }

  context "with valid parameters" do
    before do
      fill_in "article_title", with: "Test"
      fill_in "article_content", with: "This is a test"
      click_button 'Create Article'
    end

    it "doesn't redirect to the new article page" do
      expect(current_path).to_not eq(new_article_path)
    end

    it "the author is subscribed" do
      last_article = Article.last
      expect(last_article.subscriptions.last.user).to eq(last_article.author)
    end
  end
end
