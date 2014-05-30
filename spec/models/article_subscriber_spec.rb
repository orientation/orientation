require "spec_helper"

describe ArticleSubscriber do
	let!(:article) { create(:article) }
	let!(:user) { create(:user) }

	let(:article_subscriber) { described_class.new(article, user) }

	context 'subscribe' do
		subject { article_subscriber.subscribe }

		it 'adds an article_subscription_id to the user' do
			expect{ subject }.to change(
				article.subscribed_users, :count).by(1)
		end
	end

	context 'unsubscribe' do
		subject { article_subscriber.unsubscribe }

		before do
			article_subscriber.subscribe
		end

		it 'removes the article_subscription_id from the user' do
			expect{ subject }.to change(article.subscribed_users, :count).by(-1)
		end
	end

end