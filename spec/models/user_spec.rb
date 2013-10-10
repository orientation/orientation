require 'spec_helper'

describe User do
  context ".find_or_create_from_omniauth" do
    before do
      @old_user = { 'provider' => 'google_oauth2', 'uid' => '12345', 'info' => { 'name' => 'peter', 'email' => 'peter@envylabs.com' } }.with_indifferent_access
      @new_user = { 'provider' => 'google_oauth2', 'uid' => '54321', 'info' => { 'name' => 'testuser', 'email' => 'testuser@envylabs.com' } }.with_indifferent_access
    end

    let!(:existing_user) { User.create(uid: @old_user[:uid], provider: @old_user[:provider], email: @old_user[:info][:email], name: @old_user[:info][:name])}

    it "finds existing user" do
      User.find_or_create_from_omniauth(@old_user).should eq existing_user
    end

    it "creates user" do
      expect { User.find_or_create_from_omniauth(@new_user) }.to change{ User.count }.from(1).to(2)
    end
  end

  context "#notify_if_article_staleness" do
    let(:author) { article.author }
    subject { author.notify_if_article_staleness }

    context "with articles that have not previously been stale" do
      let(:article) { create(:article, :stale, last_notified_author_at: nil) }

      it "queues a delayed job" do
        expect { subject }.to create_delayed_job_with(:NotifyAuthorOfStalenessJob)
      end
    end

    context "with articles that have not yet been added to the queue" do
      let(:article) { create(:article, :stale, last_notified_author_at: 8.days.ago) }

      it "queues a delayed job" do
        expect { subject }.to create_delayed_job_with(:NotifyAuthorOfStalenessJob)
      end
    end

    context "with articles that are already queued" do
      let(:article) { create(:article, :stale, last_notified_author_at: 2.days.ago) }

      it "does not queue a delayed job" do
        expect { subject }.not_to create_delayed_job_with(:NotifyAuthorOfStalenessJob)
      end
    end
  end
end
