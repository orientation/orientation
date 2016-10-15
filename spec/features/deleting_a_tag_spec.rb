require "rails_helper"

RSpec.describe 'deleting an tag' do
  let(:tag) { create(:tag) }

  it "it should redirect to tags index" do
    visit tag_path(tag)
    click_link_or_button 'Delete'
    expect(current_path).to eq(tags_path)
  end

end
