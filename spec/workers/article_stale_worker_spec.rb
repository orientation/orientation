require 'rails_helper'

RSpec.describe ArticleStaleWorker, type: :worker do
  it "sends an ArticleMailer" do
    article = create(:article, :stale)

    mailer = class_double(ArticleMailer, deliver: true)

    expect(ArticleMailer).to receive(:send_staleness_notification_for)
      .with([article]).and_return(mailer)

    described_class.perform_async([article.id])
  end
end
