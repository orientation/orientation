require "spec_helper"

describe Article do
  context ".fresh" do
    let!(:fresh_article) { create(:article, :fresh) }
    let!(:stale_article) { create(:article, :stale) }

    let(:subject) { Article.fresh }

    it "includes fresh articles" do
      subject.should include(fresh_article)
    end

    it "does not include stale articles" do
      subject.should_not include(stale_article)
    end
  end

  context ".fresh?" do
    let(:fresh_article) { create(:article) }
    let(:stale_article) { create(:article, :stale) }

    it "is true for fresh articles" do
      Article.fresh?(fresh_article).should be_true
    end

    it "is false for stale articles" do
      Article.fresh?(stale_article).should be_false
    end
  end

  context ".stale" do
    let!(:fresh_article) { create(:article, :fresh) }
    let!(:stale_article) { create(:article, :stale) }

    let(:subject) { Article.stale }

    it "includes stale articles" do
      subject.should include(stale_article)
    end

    it "does not include fresh articles" do
      subject.should_not include(fresh_article)
    end
  end

  context ".stale?" do
    let(:fresh_article) { create(:article) }
    let(:stale_article) { create(:article, :stale) }

    it "is true for stale articles" do
      Article.stale?(stale_article).should be_true
    end

    it "is false for fresh articles" do
      Article.stale?(fresh_article).should be_false
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

  context ".ordered_fresh" do
    let!(:fresh_article) { create :article }
    let!(:fresher_article) { create :article }

    it "returns the fresher article first" do
      expect(Article.ordered_fresh.first).to eq fresher_article
    end
  end

  context "#fresh?" do
    let(:fresh_article) { create(:article, :fresh) }
    let(:stale_article) { create(:article, :stale) }

    it "returns true for a fresh article" do
      fresh_article.fresh?.should be_true
    end

    it "returns false for a non-fresh article" do
      stale_article.fresh?.should be_false
    end
  end

  context "#stale?" do
    let(:fresh_article) { create(:article, :fresh) }
    let(:stale_article) { create(:article, :stale) }

    it "returns false for a non-stale article" do
      fresh_article.stale?.should be_false
    end

    it "returns true for a stale article" do
      stale_article.stale?.should be_true
    end
  end
end
