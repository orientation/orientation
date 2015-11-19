require "rails_helper"

RSpec.describe "Viewing an article" do
  let(:article) { create(:article) }

  subject(:article_visit) { visit article_path(article) }

  it "increments the visits for this article by 1" do
    expect { article_visit }.to change { article.reload.visits }.by(1)
  end

  context "visitor visits an article" do
    let(:article) { create(:article) }

    before do
      visit article_path(article)
    end

    it "shows the article" do
      expect(page).to have_content(article.title)
      expect(current_path).to eq(article_path(article))
    end
  end

  context "visitor visits old slug" do
    let(:article) { create(:article, title: "Old Title") }
    let(:old_url) { article_path(article) }

    before do
      visit edit_article_path(article)
      fill_in "article_title", with: "New Title"
      click_button "Update Article"
    end

    it "redirects from the old url" do
      new_url = "/articles/new-title"

      visit old_url
      expect(page).to have_content(article.reload.title)
      expect(current_path).to eq(new_url)
    end
  end

  context "visitor visits article url that does not exist" do
    let(:title) { "Foo" }
    before do
      visit article_path(title)
    end

    it "redirects to the new article page with the title" do
      expect(page).to have_content("Since this article doesn't exist, it would be super nice if you wrote it. :-)")
      expect(current_path).to eq(new_article_path)
    end
  end
end


