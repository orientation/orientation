require "rails_helper"

RSpec.describe 'Creating an article' do
  before { visit new_article_path }

  subject(:create) { click_button "Create Article" }

  context "with valid parameters" do
    before do
      fill_in "article_title", with: "Test"
      fill_in "article_content", with: "This is a test"
    end

    it "doesn't redirect to the new article page" do
      expect { create }.to change { current_path }.from(new_article_path)
    end
  end
end
