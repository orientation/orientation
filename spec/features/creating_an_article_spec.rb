require "rails_helper"

RSpec.describe 'Creating an article' do
  def fill(options)
    options.each do |o|
      fill_in o.first, with: o.second
    end
  end

  before do
    visit new_article_path
    fill(
      "article_title" => "Test",
      "article_content" => "This is a test"
    )
    click_button "Create Article"
  end

  it "" do
    expect(current_path).to_not eq(new_article_path)
  end
end
