require "rails_helper"

RSpec.describe ArticleSubscription do

  context '#send_update' do
    let(:article_subscription) { create(:article_subscription) }

    before do
      Sidekiq.configure_client do |config|
        config.client_middleware do |chain|
          chain.remove SidekiqUniqueJobs::Client::Middleware
        end
      end
    end

    subject(:send_update) { article_subscription.send_update }

    it 'queues a delayed job' do
      expect { send_update }.to change(
        ArticleUpdatedWorker.jobs, :size
      ).by(1)
    end
  end
end
