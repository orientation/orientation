require 'rails_helper'

RSpec.describe ArticleOutdatedWorker, type: :worker do
  before do
    Sidekiq::Testing.inline!
  end

  it "sends an ArticleMailer" do
    article = create(:article)
    reporter = create(:user)
    contributors = article.contributors

    mailer = class_double(ArticleMailer, deliver: true)

    expect(ArticleMailer).to receive(:send_outdated_notification_for)
      .with(article, contributors, reporter).and_return(mailer)

    described_class.perform_async(article.id, reporter.id)
  end
end
