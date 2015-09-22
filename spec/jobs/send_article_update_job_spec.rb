require "rails_helper"

RSpec.describe SendArticleUpdateJob do
  it "sends an ArticleMailer" do
    article = create(:article)
    user    = create(:user)
    mailer  = double("ArticleMailer", deliver: true)

    expect(ArticleMailer).to receive(:send_updates_for)
      .with(article, user).and_return(mailer)

    described_class.perform_now(article.id, user.id)
  end
end
