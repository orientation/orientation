require "rails_helper"

RSpec.describe ArticleSubscription do

  context '#send_update' do
    let(:article_subscription) { create(:article_subscription) }

    subject(:send_update) { article_subscription.send_update }

    it 'queues a delayed job' do
      expect { send_update }.to create_delayed_job_with(:SendArticleUpdateJob)
    end
  end

  context "#updated_queued?" do
    let!(:article_subscription) { create(:article_subscription) }
    subject(:saving) { article_subscription.article.save! }

    it "returns true when the article is saved" do
      expect { saving }.to change{ article_subscription.reload.update_queued? }.to(true)
    end
  end

  context "#existing_queued_update_jobs" do
    let!(:article_subscription) { create(:article_subscription) }
    let(:article) { article_subscription.article }

    subject(:existing_queued_update_jobs) { article_subscription.existing_queued_update_jobs }

    context "with an update already queued" do
      before do
        article.subscriptions.reload
        article.save!
      end

      context "when saving the article again within 5 minutes" do
        subject(:saving) { article.save! }

        it "it replaces the queued job with a new one" do
          expect { saving }.not_to change { existing_queued_update_jobs }
        end
      end
    end
  end
end
