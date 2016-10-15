require "rails_helper"

RSpec.describe "Updating a tag" do
  let(:tag) { create(:tag) }

  before { visit edit_tag_path(tag) }

  context "with valid parameters" do
    before do
      fill_in "tag_name", with: content
      click_button "Update Tag"
    end

    context "and content" do
      let(:content) { "This is a test" }

      it "doesn't redirect to the edit page" do
        expect(current_path).to_not eq(edit_tag_path(tag))
        expect(page).to have_content "Tag was successfully updated."
      end
    end

  end

  context "with invalid parameters" do
    before("and an existing keyword") do
      create(:tag, name: "ABC")
    end

    before do
      fill_in "tag_name", with: content
      click_button "Update Tag"
    end

    context "with no content" do
      let(:content) { "" }

      it "displays an error" do
        expect(page).to have_content("Name can't be blank")
      end
    end

    context "with existing tag" do
      let(:content) { "ABC" }

      it "displays an error" do
        expect(page).to have_content("Edit a Tag")
        expect(page).to have_content("ABC has already been taken.")
      end
    end

    context "with a reserved keyword" do
      let(:content) { "new" }

      it "renders the new tag page" do
        expect(page).to have_content("Edit a Tag")
        expect(page).to have_content("new is a reserved word.")
      end
    end
  end

end
