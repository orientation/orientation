require "rails_helper"

RSpec.describe Article do
  describe ".text_search" do
    before { 100.times { create :article } }

    let!(:article) { create :article, title: "Pumpernickel Stew", content: "Yum!"}

    it "does partial title matching" do
      result = Article.text_search "Pumper"
      expect(result.first).to eq(article)
    end

    it "does full title matching" do
      result = Article.text_search article.title
      expect(result.first).to eq(article)
    end

    it "does partial content matching" do
      result = Article.text_search "yum"
      expect(result).to include(article)
    end

    it "does full content matching" do
      result = Article.text_search article.content
      expect(result).to include(article)
    end

    context "when searching for tagged articles" do
      let(:tag) { create(:tag, name: 'security') }

      before { article.tags << tag }

      it "doesn't match based on tag name" do
        result = Article.text_search tag.name
        expect(result.first).to be nil
      end

      context "when some articles include the tag name in their title" do
        before do
          @tag_in_title = create(:article, title: "Something something #{tag.name}")
        end

        it "doesn't excluse title matches" do
          result = Article.text_search tag.name
          expect(result).to include(@tag_in_title)
        end
      end
    end

    context "regression search tests" do
      before do
        @recaptcha = create(:article, title: "Account Locking and ReCaptcha")
        @securing = create(:article, title: "Securing your email communications with S/MIME")
      end

      it "finds the articles" do
        expect(Article.text_search("Account Locking")).to include(@recaptcha)
        expect(Article.text_search("email securing")).to include(@securing)
      end
    end
  end
end
