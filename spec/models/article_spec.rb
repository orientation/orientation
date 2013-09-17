require 'spec_helper'

describe Article do
  it { should belong_to :author }
  it { pending "shoulda isn't compatible with Rails 4 HABTM join tables yet."; should have_and_belong_to_many :tags }

  context '.stale' do
    let(:article) { FactoryGirl.create(:article) }
    let(:stale_article) { FactoryGirl.create(:article, :stale) }
    subject { Article.stale }

    it 'returns an array of stale articles' do
      subject.should include(stale_article)
    end

    it 'does not return un-stale articles' do
      subject.should_not include(article)
    end
  end

  context '#notify_author_of_staleness' do
    let(:article) { FactoryGirl.create(:article, :stale) }
    subject { article.notify_author_of_staleness }

    it 'sends an AuthorMailer when an article becomes stale' do
      mailer = double('AuthorMailer', deliver: true)
      
      AuthorMailer.should_receive(:notification).and_return(mailer)
      subject
    end
  end
end
