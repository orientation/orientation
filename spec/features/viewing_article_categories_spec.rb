require "rails_helper"

RSpec.describe 'Viewing the category' do
  before do
    Article.delete_all
  end

  context "for fresh articles" do
    before { visit fresh_articles_path }

    it "displays a message when no such articles are found" do
      expect(page).to have_content("There are no fresh articles.")
    end

    context "with one article" do
      before { @article = create(:article, :fresh) }

      it "lists the article" do
        visit current_path
        expect(page).to have_content(@article.title)
      end
    end
  end

  context "for stale articles" do
    before { visit stale_articles_path }

    it "displays a message when no such articles are found" do
      expect(page).to have_content("There are no stale articles.")
    end

    context "with one article" do
      before { @article = create(:article, :stale) }

      it "lists the article" do
        visit current_path
        expect(page).to have_content(@article.title)
      end
    end
  end

  context "for outdated articles" do
    before { visit outdated_articles_path }

    it "displays a message when no such articles are found" do
      expect(page).to have_content("There are no outdated articles.")
    end

    context "with one article" do
      before { @article = create(:article, :outdated) }

      it "lists the article" do
        visit current_path
        expect(page).to have_content(@article.title)
      end
    end
  end

  context "for popular articles" do
    before { visit popular_articles_path }

    it "displays a message when no such articles are found" do
      expect(page).to have_content("There are no popular articles.")
    end

    context "with one article" do
      before { @article = create(:article, :popular) }

      it "lists the article" do
        visit current_path
        expect(page).to have_content(@article.title)
      end
    end
  end

  context "for archived articles" do
    before { visit archived_articles_path }

    it "displays a message when no such articles are found" do
      expect(page).to have_content("There are no archived articles.")
    end

    context "with one article" do
      before { @article = create(:article, :archived) }

      it "lists the article" do
        visit current_path
        expect(page).to have_content(@article.title)
      end
    end
  end
end
