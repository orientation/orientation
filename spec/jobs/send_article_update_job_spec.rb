# -*- encoding : utf-8 -*-
require 'spec_helper' 

describe SendArticleUpdateJob do
  let!(:article) { create(:article) }
  let!(:user) { create(:user) }

  let(:job) { described_class.new(article.id, user.id) }
  subject(:perform_job) { job.perform }

  it "sends an ArticleMailer" do
    mailer = double("ArticleMailer", deliver: true)
    
    expect(ArticleMailer).to receive(:send_updates_for).and_return(mailer)
    perform_job
  end
end