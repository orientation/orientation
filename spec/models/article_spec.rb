require "spec_helper"

describe Article do
  context "after_save" do
    let(:article) { create(:article) }
    let(:user) { create(:user) }
    let!(:article_subscription) {
      create(:article_subscription, article: article, user: user)
    }

    before { article.subscriptions.reload }

    subject(:save_article) { article.save! }

    it "notifies ArticleSubscription about the change" do
      expect_any_instance_of(ArticleSubscription).to receive(:send_update)
      save_article
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

  context '#guide?' do
    let(:article) { create(:article) }

    context 'when the article is not set as a guide' do
      it "returns false" do
        expect(article.guide?).to be_falsey
      end
    end

    context 'when the article is set as a guide' do\
      subject(:make_guide) { article.update_attribute(:guide, true) }

      it "returns true" do
        expect { make_guide }.to change { article.guide? }.from(false).to(true)
      end
    end

    context 'when an article is no longer a guide' do
      before { article.update_attribute(:guide, false) }

      it "returns false" do
        expect(article.guide?).to be_falsey
      end
    end
  end

  context '.guide' do
    let!(:guide_article) { create(:article, :guide) }
    let!(:article) { create(:article) }

    subject(:guide) { Article.guide }

    it "includes guide articles" do
      expect(guide).to include(guide_article)
    end

    it "doesn't include non-guide articles" do
      expect(guide).to_not include(article)
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
    let!(:stale_article) { create(:article, :stale) }

    subject(:fresh_articles) { Article.fresh }

    it "includes fresh articles" do
      expect(fresh_articles).to include(fresh_article)
    end

    it "does not include stale articles" do
      expect(fresh_articles).not_to include(stale_article)
    end
  end

  context "#fresh?" do
    let(:fresh_article) { create(:article) }
    let(:stale_article) { create(:article, :stale) }

    it "is true for fresh articles" do
      expect(fresh_article.fresh?).to be_truthy
    end

    it "is false for stale articles" do
      expect(stale_article.fresh?).to be_falsey
    end
  end

  context ".stale" do
    let!(:fresh_article) { create(:article, :fresh) }
    let!(:stale_article) { create(:article, :stale) }

    subject(:stale_articles) { Article.stale }

    it "includes stale articles" do
      expect(stale_articles).to include(stale_article)
    end

    it "does not include fresh articles" do
      expect(stale_articles).not_to include(fresh_article)
    end
  end

  context "#stale?" do
    let(:fresh_article) { create(:article) }
    let(:stale_article) { create(:article, :stale) }

    it "is true for stale articles" do
      expect(stale_article.stale?).to be_truthy
    end

    it "is false for fresh articles" do
      expect(fresh_article.stale?).to be_falsey
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

    context 'with a recently created rotten article' do
      before { recent_article.rot! }

      it "doesn't return the rotten article first" do
        expect(Article.ordered_current.first).to_not eq recent_article
      end

      it "returns the rotten article last" do
        expect(Article.ordered_current.last).to eq recent_article
      end
    end

    context 'with a recently updated rotten article' do
      before { recent_article.rot!; recent_article.touch }

      it "doesn't return the rotten article first" do
        expect(Article.ordered_current.first).to_not eq recent_article
      end

      it "returns the rotten article last" do
        expect(Article.ordered_current.last).to eq recent_article
      end
    end
  end

  context ".ordered_fresh" do
    let!(:recent_article) { create :article }
    let!(:more_recent_article) { create :article }
    let!(:archived_article) { create :article, :archived }
    let!(:rotten_article) { create :article, :rotten }

    subject(:ordered_fresh) { Article.ordered_fresh }

    it "returns the more recent article first" do
      expect(ordered_fresh.first).to eq more_recent_article
    end

    it "does not include archived articles" do
      expect(ordered_fresh).to_not include(archived_article)
    end

    it "does not include rotten articles" do
      expect(ordered_fresh).to_not include(archived_article)
    end

    context "with an updated article" do
      before { recent_article.touch }

      it "returns the updated article first" do
        expect(ordered_fresh.first).to eq recent_article
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

    context 'with a stale article' do
      let(:article) { create(:article, :stale) }

      it "returns false" do
        expect(fresh?).to be_falsey
      end
    end

    context 'with a rotten article' do
      let(:article) { create(:article, :rotten) }

      it "returns false" do
        expect(fresh?).to be_falsey
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

    context 'with a stale article' do
      let(:article) { create(:article, :stale) }

      it "makes it fresh" do
        expect { refresh! }.to change { article.fresh? }
      end
    end

    context 'with a rotten article' do
      let(:article) { create(:article, :rotten) }

      it "makes it fresh" do
        expect { refresh! }.to change { article.fresh? }
      end
    end
  end

  context "#rot!" do
    subject(:rot!) { article.rot! }

    context 'with a fresh article' do
      let(:article) { create(:article, :fresh) }

      it "makes it rotten" do
        expect { rot! }.to change { article.reload.rotten? }
      end
    end

    context 'with a stale article' do
      let(:article) { create(:article, :stale) }

      it "makes it rotten" do
        expect { rot! }.to change { article.reload.rotten? }
      end
    end

    context 'with a rotten article' do
      let(:article) { create(:article, :rotten) }

      it "keeps it rotten" do
        expect { rot! }.not_to change { article.rotten? }
      end
    end
  end

  context "#rotten?" do
    let(:fresh_article) { create(:article, :fresh) }
    let(:stale_article) { create(:article, :stale) }
    let(:rotten_article) { create(:article, :rotten) }

    it "returns false for a fresh article" do
      expect(fresh_article.rotten?).to be_falsey
    end

    it "returns false for a stale article" do
      expect(stale_article.rotten?).to be_falsey
    end

    it "returns true for a rotten article" do
      expect(rotten_article.rotten?).to be_truthy
    end
  end

  context "#stale?" do
    let(:fresh_article) { create(:article, :fresh) }
    let(:stale_article) { create(:article, :stale) }

    it "returns false for a non-stale article" do
      expect(fresh_article.stale?).to be_falsey
    end

    it "returns true for a stale article" do
      expect(stale_article.stale?).to be_truthy
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

  context 'tags_count' do
    let!(:article) { create(:article) }
    let!(:article_tag_count) { article.tags_count }

    context 'when a tag is added' do
      subject(:add_tag) { create(:tag, articles: [article]) }

      it "increases" do
        expect { add_tag }.to change { article.tags_count }.by(1)
      end
    end

    context 'when a tag is removed' do
      let!(:tag) { create(:tag, articles: [article]) }

      subject(:remove_tag) { article.tags.reload.first.destroy }

      it "decreases" do
        expect { remove_tag }.to change { article.reload.tags_count }.by(-1)
      end
    end

  end
end
