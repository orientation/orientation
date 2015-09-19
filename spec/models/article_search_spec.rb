require "rails_helper"

RSpec.describe Article do
  describe ".text_search" do
    before(:all) do
      100.times { create :article }
      @article1 = create(:article, title: "Pumpernickel Stew is not so great", content: "Yum")
      @article2 = create(:article, title: "There is no cheese but French cheese", content: "Truth")
    end

    let!(:article) { }

    it "does partial title matching on the first word in the title" do
      result = Article.text_search "Pumpernickel"
      expect(result.first).to eq(@article1)
    end

    it "does partial title matching on the last word in the title" do
      result = Article.text_search "great"
      expect(result.first).to eq(@article1)
    end

    it "does partial title matching on non-contiguous words in the title" do
      result = Article.text_search "not great"
      expect(result.first).to eq(@article1)
    end

    it "does full title matching" do
      result = Article.text_search @article1.title
      expect(result.first).to eq(@article1)
    end

    it "does match with with proper boolean AND operators" do
      result = Article.text_search "not & pumpernickel"
      expect(result.first).to eq(@article1)
    end

    it "doesn't match with with improper boolean AND operators" do
      result = Article.text_search "tough & pumpernickel"
      expect(result.first).to_not eq(@article1)
    end

    it "does match with with improper boolean AND operators" do
      result = Article.text_search "tough & pumpernickel"
      expect(result.first).to_not eq(@article1)
    end

    it "doesn't do partial content matching" do
      result = Article.text_search "yum"
      expect(result).to_not include(@article1)
    end

    it "doesn't do full content matching" do
      result = Article.text_search @article1.content
      expect(result).to_not include(@article1)
    end

    context "when searching for tagged articles" do
      let(:tag) { create(:tag, name: 'security') }

      before { @article1.tags << tag }

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
