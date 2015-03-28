require 'spec_helper'

describe 'Viewing an article' do
  let(:article) { create(:article) }

  subject(:article_visit) { visit article_path(article) }

  it "increments the visits for this article by 1" do
    expect { article_visit }.to change { article.reload.visits }.by(1)
  end
end
