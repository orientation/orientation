require "rails_helper"

RSpec.describe Article do
  describe "#after_destroy" do
    let(:article) { create(:article) }
    let(:speakerphone) { double(:speakerphone, shout: 'foo') }

    it 'notifies slack that it has been destroyed' do
      expect(Speakerphone).to receive(:new).with(article, :destroyed).and_return(speakerphone)
      article.destroy
    end
  end

  describe "#subscribe" do
    let(:author) { create(:user) }
    let(:article) { create(:article, author: author) }

    it 'creates a subscription that belongs to the author' do
      article.subscribe(author)
      expect(article.subscriptions.last.user_id).to eq(author.id)
    end
  end

  describe "#after_save" do
    let(:article) { create(:article) }
    let(:user) { create(:user) }
    let!(:article_subscription) { create(:article_subscription, article: article, user: user) }

    before { article.subscriptions.reload }

    subject(:save_article) { article.save! }

    it "notifies ArticleSubscription about the change" do
      expect_any_instance_of(ArticleSubscription).to receive(:send_update)
      save_article
    end
  end

  describe ".count_visit(article)" do
    let(:article) { create(:article, :stale) }

    subject(:count_visit) { described_class.count_visit(article) }

    it "increments the visits column" do
      expect { count_visit }.to change { article.reload.visits }.by(1)
    end

    it "doesn't change the updated_at timestamp" do
      expect { count_visit }.not_to change { article.reload.updated_at }
    end
  end

  describe "#count_visit" do
    let(:article) { create(:article) }

    subject(:count_visit) { article.count_visit }

    it "increments the visits" do
      expect { count_visit }.to change { article.reload.visits }.by(1)
    end
  end

  describe "#subscribers_to_update" do
    let(:author) { create(:user) }
    let(:editor) { create(:user) }
    let(:article) { create(:article, author: author, editor: editor) }
    let!(:author_sub) do
      create(:article_subscription, article: article, user: author)
    end
    let!(:editor_sub) do
      create(:article_subscription, article: article, user: editor)
    end

    subject { article.reload.subscribers_to_update }

    it "does not include the editor's subscription" do
      expect(subject).to_not include(editor_sub)
    end

    it 'returns other subscriptions' do
      expect(subject).to include(author_sub)
    end

  end

  describe '#author?(user)' do
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

  describe '#guide?' do
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

  describe '.guide' do
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

  describe '.popular' do
    before { 5.times { create(:article) } }

    subject(:most_popular_article) { Article.popular.first }

    context "with a subscribed to article" do
      let!(:article) { create(:article_subscription).article }

      it "returns the article with a subscription first" do
        expect(most_popular_article).to eq(article)
      end
    end

    context "with an endorsed article" do
      let!(:article) { create(:article_endorsement).article }

      it "returns the article with an endorsement first" do
        expect(most_popular_article).to eq(article)
      end
    end

    context "with a visited article" do
      let!(:article) { create(:article, :popular) }

      it "returns the article with a visit first" do
        expect(most_popular_article).to eq(article)
      end
    end
  end

  describe ".fresh" do
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

  describe '#fresh?' do
    subject { described_class.new }

    context 'when it is archived' do
      before { subject.archived_at = Time.current }
      it { should_not be_fresh }
    end

    context 'when it is rotten' do
      before { subject.rotted_at = Time.current }
      it { should_not be_fresh }
    end

    context 'when it is neither archived nor rotten' do
      context 'and when time since updated exceeds the FRESHNESS_LIMIT' do
        before { subject.updated_at = (described_class::FRESHNESS_LIMIT + 1.minute).ago }
        it { should_not be_fresh }
      end

      context 'and when time since updated is within the FRESHNESS_LIMIT' do
        before { subject.updated_at = (described_class::FRESHNESS_LIMIT - 1.minute).ago }
        it { should be_fresh }
      end
    end
  end

  describe ".stale" do
    let!(:fresh_article) { create(:article, :fresh) }
    let!(:stale_article) { create(:article, :stale) }
    let!(:rotten_article) { create(:article, :rotten) }

    subject(:stale_articles) { Article.stale }

    it "includes stale articles" do
      expect(stale_articles).to include(stale_article)
    end

    it "does not include fresh articles" do
      expect(stale_articles).not_to include(fresh_article)
    end

    it "does not include rotten articles" do
      expect(stale_articles).not_to include(rotten_article)
    end
  end

  describe "#stale?" do
    subject { described_class.new }

    context 'when time since updated exceeds the STALENESS_LIMIT' do
      before { subject.updated_at = (described_class::STALENESS_LIMIT + 1.minute).ago }
      it { should be_stale }
    end

    context 'when time since updated is within the STALENESS_LIMIT' do
      before { subject.updated_at = (described_class::STALENESS_LIMIT - 1.minute).ago }
      it { should_not be_stale }
    end
  end

  describe ".recent" do
    let!(:recent_article) { create :article }
    let!(:more_recent_article) { create :article }

    subject(:recent) { Article.recent }

    it "returns the more recent article first" do
      expect(recent.first).to eq more_recent_article
    end

    context "with an updated article" do
      before { recent_article.touch }

      it "returns the updated article first" do
        expect(recent.first).to eq recent_article
      end
    end
  end

  describe ".current" do
    let!(:recent_article) { create :article }
    let!(:more_recent_article) { create :article }

    subject(:recent) { Article.recent }

    it "returns the more recent article first" do
      expect(recent.first).to eq more_recent_article
    end

    context "with an updated article" do
      before { recent_article.touch }

      it "returns the updated article first" do
        expect(recent.first).to eq recent_article
      end
    end
  end

  describe "#archive!" do
    let!(:article) { create :article }

    subject(:archive_article) { article.archive! }

    it "removes the article from current articles" do
      expect { archive_article }.to change { Article.current.count }.by(-1)
    end
  end

  describe '#archived?' do
    subject { described_class.new }

    context 'when archived_at is not set' do
      specify { expect(subject.archived?).to be false }
    end

    context 'when archived_at is set' do
      before { subject.archived_at = Time.current }
      specify { expect(subject.archived?).to be true }
    end
  end

  describe "#refresh!" do
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

  describe "#rot!(user_id)" do
    let(:reporter) { create(:user) }

    subject(:rot!) { article.rot!(reporter.id) }

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

  describe '#rotten?' do
    subject { described_class.new }

    context 'when rotted_at is not set' do
      it { should_not be_rotten }
    end

    context 'when rotted_at is set' do
      before { subject.rotted_at = Time.current }
      it { should be_rotten }
    end
  end

  describe "#stale?" do
    let(:fresh_article) { create(:article, :fresh) }
    let(:stale_article) { create(:article, :stale) }

    it "returns false for a non-stale article" do
      expect(fresh_article.stale?).to be_falsey
    end

    it "returns true for a stale article" do
      expect(stale_article.stale?).to be_truthy
    end
  end

  describe "#unarchive!" do
    let!(:article) { create :article }

    subject(:unarchive_article) { article.unarchive! }

    before { article.archive! }

    it "add the article to current articles" do
      expect { unarchive_article }.to change { Article.current.count }.by(1)
    end
  end

  describe 'tags_count' do
    let!(:article) { create(:article) }

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

  describe "subscriptions_count" do
    let!(:article) { create(:article) }

    context 'when a subscription is added' do
      subject(:add_subscription) { create(:article_subscription, article: article) }

      it "increases" do
        expect { add_subscription }.to change { article.subscriptions_count }.by(1)
      end
    end

    context 'when a subscription is removed' do
      let!(:subscription) { create(:article_subscription, article: article) }

      subject(:remove_subscription) { article.subscriptions.reload.first.destroy }

      it "decreases" do
        expect { remove_subscription }.to change { article.reload.subscriptions_count }.by(-1)
      end
    end
  end

  describe "endorsements_count" do
    let!(:article) { create(:article) }

    context 'when a endorsement is added' do
      subject(:add_endorsement) { create(:article_endorsement, article: article) }

      it "increases" do
        expect { add_endorsement }.to change { article.endorsements_count }.by(1)
      end
    end

    context 'when a endorsement is removed' do
      let!(:endorsement) { create(:article_endorsement, article: article) }

      subject(:remove_endorsement) { article.endorsements.reload.first.destroy }

      it "decreases" do
        expect { remove_endorsement }.to change { article.reload.endorsements_count }.by(-1)
      end
    end
  end
end
