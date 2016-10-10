require "rails_helper"

RSpec.describe 'deleting an author' do
  let!(:logged_in_user) { create(:user) }
  let(:author) { create(:user) }

  it "should redirect to authors index" do
    visit author_path(author.id)

    expect do
      click_link_or_button 'Delete Author'
      expect(current_path).to eq(authors_path)
    end.to change { User.where(id: author.id).count }.from(1).to(0)
  end

  it "should not delete itself" do
    visit author_path(logged_in_user.id)

    expect do
      click_link_or_button 'Delete Author'
      expect(current_path).to eq(author_path(logged_in_user.id))
    end.not_to change { User.where(id: author.id).count }
  end
end
