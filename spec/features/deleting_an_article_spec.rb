require "rails_helper"

RSpec.describe 'deleting an article' do
  let(:article) { create(:article) }

  it "it should redirect to articles index" do
    visit article_path(article)
    click_link_or_button 'Delete'
    expect(current_path).to eq(articles_path)
  end

end
