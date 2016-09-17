require "rails_helper"

RSpec.describe User do
  context ".find_or_create_from_omniauth" do
    before do
      @old_user = { 'provider' => 'google_oauth2', 'uid' => '12345', 'info' => { 'name' => 'peter', 'email' => 'peter@hanso.dk' } }.with_indifferent_access
      @new_user = { 'provider' => 'google_oauth2', 'uid' => '54321', 'info' => { 'name' => 'testuser', 'email' => 'testuser@hanso.dk' } }.with_indifferent_access
      @other_user = { 'provider' => 'google_oauth2', 'uid' => '54321', 'info' => { 'name' => 'testuser', 'email' => 'other@example.com' } }.with_indifferent_access
    end

    let!(:existing_user) { User.create(uid: @old_user[:uid], provider: @old_user[:provider], email: @old_user[:info][:email], name: @old_user[:info][:name])}
    let(:old_user) { User.find_or_create_from_omniauth(@old_user) }

    it "finds existing user" do
      expect(old_user).to eq existing_user
    end

    it "creates the user" do
      expect { User.find_or_create_from_omniauth(@new_user) }.to change{ User.count }.by(1)
    end

    context "when email_whitelist_enabled? returns false" do
      it "doesn't denies unauthorized user" do
        with_modified_env(ORIENTATION_EMAIL_WHITELIST: nil) do
          expect(User.find_or_create_from_omniauth(@other_user).valid?).to be_truthy
        end
      end
    end

    context "when email_whitelist_enabled? returns true" do
      it "denies access to a user whose email address isn't included in the whitelist" do
        with_modified_env(ORIENTATION_EMAIL_WHITELIST: "codeschool.com:pluralsight.com") do
          expect(User.find_or_create_from_omniauth(@other_user).valid?).to be_falsey
        end
      end
    end
  end

  context "#notify_about_stale_articles" do
    let(:author) { article.author }
    subject(:notify_about_stale_articles) { author.notify_about_stale_articles }

    context "with articles that have not previously been stale" do
      let(:article) { create(:article, :stale, last_notified_author_at: nil) }

      it "queues a delayed job" do
        expect { notify_about_stale_articles }.to create_delayed_job_with(:StalenessNotificationJob)
      end

      context 'with an inactive author' do
        before { author.toggle!(:active) }

        it "returns false" do
          expect(notify_about_stale_articles).to be_falsey
        end

        it "does not queue a delayed job" do
          expect { notify_about_stale_articles }.not_to create_delayed_job_with(:StalenessNotificationJob)
        end
      end
    end

    context "with articles that have not yet been added to the queue" do
      let(:article) { create(:article, :stale, last_notified_author_at: 8.days.ago) }

      it "queues a delayed job" do
        expect { notify_about_stale_articles }.to create_delayed_job_with(:StalenessNotificationJob)
      end
    end

    context "with articles that are already queued" do
      let(:article) { create(:article, :stale, last_notified_author_at: 2.days.ago) }

      it "does not queue a delayed job" do
        expect { notify_about_stale_articles }.not_to create_delayed_job_with(:StalenessNotificationJob)
      end
    end
  end

  context "#subscribed_to?(article)" do
    let(:user) { create(:user) }
    let(:article) { create(:article) }
    let!(:article_subscription) { create(:article_subscription, user: user, article: article) }

    subject(:subscribed_to?) { user.subscribed_to?(article) }

    it 'returns the correct value' do
      expect(subscribed_to?).to be_truthy
    end
  end
end
