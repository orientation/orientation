require "spec_helper"

describe Article do
  it { should belong_to :author }
  it { pending "shoulda isn't compatible with Rails 4 HABTM join tables yet."; should have_and_belong_to_many :tags }

  context ".fresh?" do
    let(:fresh_article) { create(:article) }
    let(:stale_article) { create(:article, :stale) }

    it "is true for fresh articles" do
      expect(fresh_article).to be_fresh
    end

    it "is false for stale articles" do
      expect(stale_article).not_to be_fresh
    end
  end

  context ".stale?" do
    let(:fresh_article) { create(:article) }
    let(:stale_article) { create(:article, :stale) }

    it "is true for stale articles" do
      expect(stale_article).to be_stale
    end

    it "is false for fresh articles" do
      expect(fresh_article).not_to be_stale
    end
  end

  context "#notify_author_of_staleness" do
    let(:article) { create(:article, :stale) }
    subject { article.notify_author_of_staleness }

    it "sends an AuthorMailer when an article becomes stale" do
      mailer = double("AuthorMailer", deliver: true)
      
      ArticleMailer.should_receive(:notify_author_of_staleness).and_return(mailer)
      subject
    end
  end
end
