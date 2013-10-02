require 'spec_helper'
 
describe ArticleMailer do
  context "notify_author_of_staleness" do
    let(:user) { FactoryGirl.create(:user, email: 'aimee@envylabs.com') }
    let(:article) { FactoryGirl.create(:article, :stale, author: user)}
    let(:mailer) { described_class.notify_author_of_staleness(article) }

    subject { mailer }

    it { should send_email_to(email: user.email) }
    it { should use_template('Stale Article Alert') }
    it { should have_subject('Stale Article Alert') }
    it { should be_from(email: 'orientation@codeschool.com') }

    describe 'merge vars' do
      it { should have_merge_data('ARTICLE_TITLE' => article.title) }
      it { should have_merge_data('ARTICLE_URL' => edit_article_url(article)) }
    end

  end
end