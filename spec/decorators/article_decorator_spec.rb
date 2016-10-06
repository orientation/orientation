require "rails_helper"

RSpec.describe ArticleDecorator do
  describe "#authors" do
    let(:author) { create(:user) }
    let(:expected_author_with_created_at) do
      "#{subject.author.link_tag} #{subject.created_at_tag}"
    end
    subject { described_class.new(article) }

    context "without an editor" do
      let(:article) { create(:article, created_at: Time.at(0), author: author) }

      it "displays a link to the author and the created_at time" do
        expect(subject.authors).to eq(expected_author_with_created_at)
      end
    end

    context "with an editor who is also the author" do
      let(:article) do
        create(
          :article,
          created_at: Time.at(0),
          updated_at: Time.at(1),
          author: author,
          editor: author
        )
      end

      it "displays a link to the author, created_at time and the updated at time" do
        expect(subject.authors).to eq(
          "#{expected_author_with_created_at} and updated on #{subject.updated_at_tag}"
        )
      end
    end

    context "with an editor who is not the author" do
      let(:editor) { create(:user) }
      let(:article) do
        create(
          :article,
          created_at: Time.at(0),
          updated_at: Time.at(1),
          author: author,
          editor: editor
        )
      end

      it "displays a link to the author, created_at time and the editor with updated at time" do
        expect(subject.authors).to eq(
          "#{expected_author_with_created_at} and updated by #{subject.editor_email_tag} on #{subject.updated_at_tag}"
        )
      end
    end
  end
end
