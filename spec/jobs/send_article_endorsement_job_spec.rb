require "rails_helper"

RSpec.describe SendArticleEndorsementJob do
  it "sends an ArticleMailer" do
    endorsement   = create(:article_endorsement)
    article       = endorsement.article
    endorser      = endorsement.user
    contributors  = endorsement.article.contributors
    mailer        = double("ArticleMailer", deliver: true)

    expect(ArticleMailer).to receive(:send_endorsement_notification_for)
      .with(article, contributors, endorser).and_return(mailer)

    described_class.perform_now(endorsement.id)
  end
end
