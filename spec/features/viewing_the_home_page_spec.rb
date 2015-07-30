require "rails_helper"

RSpec.describe 'Viewing the home page' do
  subject(:home_visit) { visit root_path }

  context "when there are no guide articles" do
    before { Article.guide.destroy_all }

    it "redirects to the article index" do
      expect { home_visit }.to change { current_path }.to(articles_path)
    end
  end

  context "when there are guide articles" do
    before { create(:article, :guide) }

    it "displays the guide index" do
      expect { home_visit }.to change { current_path }.to(root_path)
    end

    context "and regular articles" do
      before { create(:article) }

      it "also displays the guide index" do
        expect { home_visit }.to change { current_path }.to(root_path)
      end
    end
  end
end
