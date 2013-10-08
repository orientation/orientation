# -*- encoding : utf-8 -*-
require 'spec_helper' 

describe NotifyAuthorOfStalenessJob do
	let(:article) { create(:article, :stale) }
	let(:job) { NotifyAuthorOfStalenessJob.new(article.id) }
	subject { job.perform }

	it "sends an ArticleMailer" do
	  mailer = double("ArticleMailer", deliver: true)
	  
	  ArticleMailer.should_receive(:notify_author_of_staleness).and_return(mailer)
	  subject
	end
	
	it "sets the article's last_notified_author_at to the date the job is run" do
		subject
		article.reload.last_notified_author_at.should eq(Date.today)
	end

	it "does not modify the updated_at value" do
		subject
		article.reload.updated_at.should be_within(0.1).of(article.created_at)
	end
end