require 'spec_helper'
 
describe ArticleMailer do
  context "notify_author_of_staleness" do
    let(:user) { create(:user, email: 'aimee@envylabs.com') }
    let(:articles) { [create(:article, :stale, author: user)] }
    let(:mailer) { described_class.notify_author_of_staleness(articles) }

    subject { mailer }

    it { should send_email_to(email: user.email) }
    it { should use_template('Stale Article Alert') }
    it { should have_subject('Some of your Orientation articles might be stale') }
    it { should be_from(email: 'orientation@codeschool.com') }

  end
end