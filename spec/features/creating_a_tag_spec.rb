require "rails_helper"

RSpec.describe "Creating an tag" do
  let(:tag) { create(:tag) }
  before { visit new_tag_path }

  context "with valid parameters" do

    before do
      fill_in "tag_name", with: content
      click_button "Create Tag"
    end

    context "and content" do
      let(:content) { "This is a test" }

      it "doesn't redirect to the new tag page" do
        expect(current_path).to_not eq(new_tag_path)
        expect(page).to have_content "Tag was successfully created."
      end
    end

  end

  context "with invalid parameters" do
    before("and an existing keyword") do
      create(:tag, name: "ABC")
    end

    before do
      fill_in "tag_name", with: content
      click_button "Create Tag"
    end

    context "and no content" do
      let(:content) { "" }

      it "renders the new tag page" do
        expect(page).to have_content("Create a New Tag")
        expect(page).to have_content("Name can't be blank.")
      end
    end
    context "and a reserved keyword" do
      let(:content) { "new" }

      it "renders the new tag page" do
        expect(page).to have_content("Create a New Tag")
        expect(page).to have_content("new is a reserved word.")
      end
    end

    context "and an existing keyword" do
      let(:content) { "ABC" }

      it "renders the new tag page" do
        expect(page).to have_content("Create a New Tag")
        expect(page).to have_content("ABC has already been taken.")
      end
    end
  end
end
