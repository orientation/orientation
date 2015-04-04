# -*- encoding : utf-8 -*-
require 'spec_helper'

describe StalenessNotificationJob do
  # NOTE: commented out because now RSpec exists with 1 on skipped specs
  # through a before(:all).
  #
  # before(:all) { skip "Staleness notification jobs have been disabled for now." }

  # before do
  #   allow(ArticleMailer).to receive(:notify_author_of_staleness) { mailer }
  # end

  # let(:mailer) { double("ArticleMailer", deliver: true) }
  # let(:articles) { [create(:article, :stale)] }

  # subject(:perform_job) { StalenessNotificationJob.new(articles).perform }

  # it "sends an ArticleMailer" do
  #   expect(mailer).to receive(:deliver)
  #   perform_job
  # end

  # context "as side-effects" do
  #   before { perform_job }

  #   it "sets each article's last_notified_author_at to the date the job is run" do
  #     expect(articles.last.reload.last_notified_author_at).to eq Date.today
  #   end

  #   it "does not modify the updated_at value" do
  #     expect(articles.last.updated_at).to be_within(0.1).of(articles.last.created_at)
  #   end
  # end
end
