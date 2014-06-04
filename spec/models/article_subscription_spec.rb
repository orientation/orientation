require "spec_helper"

describe ArticleSubscription do
	let!(:article) { create(:article) }
	let!(:user) { create(:user) }

	context 'after_create' do
		subject { described_class.create(article: article, user: user) }

		it 'creates a delayed job' do
			expect { subject }.to create_delayed_job_with(:SendArticleUpdateJob)
		end
	end
end
