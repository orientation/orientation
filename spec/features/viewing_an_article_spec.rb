require "rails_helper"

RSpec.describe "Viewing an article" do
  let(:article) { create(:article) }

  subject(:article_visit) { visit article_path(article) }

  it "increments the visits for this article by 1" do
    expect { article_visit }.to change { article.reload.visits }.by(1)
  end

  context "when visiting an article" do
    let(:article) { create(:article) }

    before { visit article_path(article) }

    it "shows the article" do
      expect(page).to have_content(article.title)
      expect(current_path).to eq(article_path(article))
    end

    context "that is stale" do
      let(:article) { create(:article, :stale) }

      it "displays an outdated banner" do
        expect(page).to have_content("This article has gone stale")
      end
    end

    context "that is outdated" do
      let(:article) { create(:article, :outdated) }

      it "displays an outdated banner" do
        expect(page).to have_content("marked this article as outdated")
      end
    end

    context "with a heading" do
      let(:article) { create(:article, content: "## Heading") } 

      it "displays a table of contents" do
        expect(page).to have_content("Table of Contents")
      end
    end
  end

  context "when visiting an article with an old slug" do
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

  context "when visiting an article url that doesn't exist" do
    let(:title) { "Foo" }

    before { visit article_path(title) }

    it "redirects to the new article page with the title" do
      expect(page).to have_content("Since this article doesn't exist, it would be super nice if you wrote it. :-)")
      expect(current_path).to eq(new_article_path)
    end
  end
end


