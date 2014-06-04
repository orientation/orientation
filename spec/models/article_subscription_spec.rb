require "spec_helper"

describe ArticleSubscription do

  context '#send_update_for(article_id)' do
    let(:article) { create(:article) }
    let(:user) { create(:user) }
    let(:article_subscription) { 
      create(:article_subscription, article: article, user: user)
    }

    subject { article_subscription.send_update_for(article.id) }

    it 'queues a delayed job' do
      expect{ subject }.to create_delayed_job_with(:SendArticleUpdateJob)
    end 
  end
end