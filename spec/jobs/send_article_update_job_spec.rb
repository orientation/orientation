require "rails_helper"

RSpec.describe SendArticleUpdateJob do
  let!(:article) { create(:article) }
  let(:user) { create(:user) }
  let(:mailer) { double("ArticleMailer", deliver: true) }

  it "sends an ArticleMailer" do
    expect(ArticleMailer).to receive(:send_updates_for)
      .with(article, user).and_return(mailer)

    described_class.perform_now(article.id, user.id)
  end

  it "updates the article's change_last_communicated_at timestamp" do
    expect(ArticleMailer).to receive(:send_updates_for).and_return(mailer)
    expect_any_instance_of(Article).not_to receive(:update_subscribers)

    expect(article.change_last_communicated_at).to be_nil

    described_class.perform_now(article.id, user.id)

    expect(article.reload.change_last_communicated_at).not_to be_nil
  end
end
