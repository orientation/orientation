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

  context ".text_search" do
    let!(:article) { create :article, title: "Pumpernickel Stew", content: "Yum!"}

    it "does partial title matching" do
      result = Article.text_search "Stew"
      expect(result).to include(article)
    end

    it "does full title matching" do
      result = Article.text_search article.title
      expect(result).to include(article)
    end

    it "does partial content matching" do
      result = Article.text_search "yum"
      expect(result).to include(article)
    end

    it "does full content matching" do
      result = Article.text_search article.content
      expect(result).to include(article)
    end

    it "does partial title and content matching" do
      pending "doesn't work yet"
      result = Article.text_search "yum pumpernickel"
      expect(result).to include(article)
    end

    it "does full title and content matching" do
      pending "doesn't work yet"
      result = Article.text_search "#{article.title} #{article.content}"
      expect(result).to include(article)
    end
  end

  context ".ordered_fresh" do
    let!(:fresh_article) { create :article }
    let!(:fresher_article) { create :article }

    it "returns the fresher article first" do
      expect(Article.ordered_fresh.first).to eq fresher_article
    end
  end

  context "#notify_author_of_staleness" do
    subject { article.notify_author_of_staleness }

    context "for an article that has not previously been stale" do
      let(:article) { create(:article, :stale, last_notified_author_at: nil) }

      it "queues a delayed job" do
        expect { subject }.to create_delayed_job_with(:NotifyAuthorOfStalenessJob)
      end
    end

    context "for an article that has not yet been added to the queue" do
      let(:article) { create(:article, :stale, last_notified_author_at: 8.days.ago) }

      it "queues a delayed job" do
        expect { subject }.to create_delayed_job_with(:NotifyAuthorOfStalenessJob)
      end
    end

    context "for an article that's already queued" do
      let(:article) { create(:article, :stale, last_notified_author_at: 2.days.ago) }

      it "does not queue a delayed job" do
        expect { subject }.not_to create_delayed_job_with(:NotifyAuthorOfStalenessJob)
      end
    end

  end
end
