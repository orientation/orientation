require "rails_helper"

RSpec.describe "Updating an article" do
  let(:article) { create(:article) }

  before { visit edit_article_path(article) }

  context "with valid parameters" do
    before do
      fill_in "article_title", with: "mexican food"
      fill_in "article_content", with: content
      click_button "Update Article"
    end

    context "and content" do
      let(:content) { "This is a test" }

      it "doesn't redirect to the edit page" do
        expect(current_path).to_not eq(edit_article_path(article))
        expect(page).to have_content "Article was successfully updated."
      end
    end

    context "and no content" do
      let(:content) { "" }

      it "doesn't redirect to the edit page" do
        expect(current_path).to_not eq(edit_article_path(article))
        expect(page).to have_content "Article was successfully updated."
      end
    end
  end

  context "with invalid parameters" do
    context "with a reserved keyword" do
      before do
        fill_in "article_title", with: "javascripts"
        fill_in "article_content", with: "Here is some content"
        click_button "Update Article"
      end

      it "renders the new article page" do
        expect(page).to have_content("Edit an Article")
        expect(page).to have_content("javascripts is a reserved word.")
      end
    end
  end
end
