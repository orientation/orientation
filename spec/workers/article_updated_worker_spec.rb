require 'rails_helper'

RSpec.describe ArticleUpdatedWorker, type: :worker do
  it "sends an ArticleMailer" do
    subscription = create(:article_subscription)
    article = subscription.article
    subscriber = subscription.subscriber

    mailer  = class_double(ArticleMailer, deliver: true)

    expect(ArticleMailer).to receive(:send_updates_for)
      .with(article, subscriber).and_return(mailer)

    described_class.perform_async(article.id, subscriber.id)
  end
end
