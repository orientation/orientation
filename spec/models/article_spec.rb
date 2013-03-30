require 'spec_helper'

describe Article do
  let(:article) { FactoryGirl.build :article }

  it { should belong_to :author }
  it { pending "shoulda is being stupid with Rails 4 association reflections"; should have_and_belong_to_many :tags }
  it { should have_many :revisions }

  context "#revisions" do
    let(:editor){ FactoryGirl.create(:user) }
    let(:revision) { FactoryGirl.create(:revision, editor: editor) }

    context "creating an article" do
      before do
        article.save
      end

      it "has one revision that matches the article content" do
        article.revisions.count.should eq 1
        article.revisions.first.content.should match article.content
      end
    end

    context "updating an article"
  end
end