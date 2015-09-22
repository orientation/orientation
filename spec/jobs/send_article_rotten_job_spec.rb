require "rails_helper"

RSpec.describe SendArticleRottenJob do
  it "sends an ArticleMailer" do
    article       = create(:article)
    reporter      = create(:user)
    contributors  = article.contributors
    mailer        = double("ArticleMailer", deliver: true)

    expect(ArticleMailer).to receive(:send_rotten_notification_for)
      .with(article, contributors, reporter).and_return(mailer)

    described_class.perform_now(article.id, reporter.id)
  end
end
