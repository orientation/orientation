require 'spec_helper'

describe ArticleMailer do
  let(:user) { create(:user, email: 'aimee@codeschool.com') }

  context ".send_updates_for(article, user)" do
    let(:article) { create(:article) }
    let(:mailer) { described_class.send_updates_for(article, user) }

    subject { mailer }

    it { should send_email_to(email: user.email) }
    it { should use_template('Article Subscription Update') }
    it { should have_subject('Article Subscription Update') }
    it { should be_from(email: 'orientation@codeschool.com') }
  end
end
