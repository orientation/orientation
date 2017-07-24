require 'rails_helper'

RSpec.describe ArticleEndorsementWorker, type: :worker do
  before do
    Sidekiq::Testing.inline!
  end

  it "sends an ArticleMailer" do
    endorsement = create(:article_endorsement)
    article = endorsement.article
    endorser = endorsement.endorser

    mailer = class_double(ArticleMailer, deliver: true)

    expect(ArticleMailer).to receive(:send_endorsement_notification_for)
      .with(article, article.contributors, endorser).and_return(mailer)

    described_class.perform_async(endorsement.id)
  end
end
