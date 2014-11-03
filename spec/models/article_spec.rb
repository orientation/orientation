require "spec_helper"

describe Article do
  context "after_save" do
    let(:article) { create(:article) }
    let(:user) { create(:user) }
    let!(:article_subscription) {
      create(:article_subscription, article: article, user: user)
    }

    let(:subject) { article.save!}

    it "notifies ArticleSubscription about the change" do
      ArticleSubscription.any_instance.should_receive(:send_update_for).with(article.reload.id)
      subject
    end
  end

  context '#author?(user)' do
    let!(:article) { create(:article) }
    let(:user) { nil }

    subject(:author?) { article.author?(user) }

    context 'when the user is the article author' do
      let(:user) { article.author }

      it "returns true" do
        expect(author?).to be_truthy
      end
    end

    context 'when the user is not the article author' do
      let(:user) { create(:user) }

      it "return false" do
        expect(author?).to be_falsey
      end
    end
  end

  context '.popular' do
    let(:articles) do
      5.times { create(:article) }
      Article.all
    end
    let(:first_article) { articles.first }
    let!(:subscriber) { create(:article_subscription, article: first_article ) }

    it "returns the 5 most subscribed to article first" do
      expect(Article.popular.first).to eq(first_article)
    end
  end

  context ".fresh" do
    let!(:fresh_article) { create(:article, :fresh) }

    let(:subject) { Article.fresh }

    it "includes fresh articles" do
      subject.should include(fresh_article)
    end
  end

  context ".fresh?" do
    let(:fresh_article) { create(:article) }

    it "is true for fresh articles" do
      Article.fresh?(fresh_article).should be_truthy
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
  end

  context ".ordered_current" do
    let!(:recent_article) { create :article }
    let!(:more_recent_article) { create :article }
    let!(:archived_article) { create :article, :archived }

    it "returns the more recent article first" do
      expect(Article.ordered_current.first).to eq more_recent_article
    end

    it "does not include archived articles" do
      expect(Article.ordered_current).to_not include(archived_article)
    end
  end

  context ".ordered_fresh" do
    let!(:recent_article) { create :article }
    let!(:more_recent_article) { create :article }
    let!(:archived_article) { create :article, :archived }

    it "returns the more recent article first" do
      expect(Article.ordered_fresh.first).to eq more_recent_article
    end

    it "does not include archived articles" do
      expect(Article.ordered_fresh).to_not include(archived_article)
    end

    context "with an updated article" do
      before { recent_article.touch }

      it "returns the updated article first" do
        expect(Article.ordered_fresh.first).to eq recent_article
      end
    end
  end

  context "#archive!" do
    let!(:article) { create :article }

    subject(:archive_article) { article.archive! }

    it "removes the article from current articles" do
      expect { archive_article }.to change { Article.current.count }.by(-1)
    end
  end

  context "#fresh?" do
    subject(:fresh?) { article.fresh? }

    context 'with a fresh article' do
      let(:article) { create(:article, :fresh) }

      it "returns true" do
        expect(fresh?).to be_truthy
      end
    end
  end

  context "#refresh!" do
    subject(:refresh!) { article.refresh! }

    context 'with a fresh article' do
      let(:article) { create(:article, :fresh) }

      it "keeps it fresh" do
        expect { refresh! }.not_to change { article.fresh? }
      end
    end
  end

  context "#unarchive!" do
    let!(:article) { create :article }

    subject(:unarchive_article) { article.unarchive! }

    before { article.archive! }

    it "add the article to current articles" do
      expect { unarchive_article }.to change { Article.current.count }.by(1)
    end
  end
end
