require 'spec_helper'

describe ArticleMailer do
  let(:user) { create(:user, email: 'aimee@codeschool.com') }

  context ".notify_author_of_staleness" do
    let(:articles) do
      3.times { create(:article, :stale, author: user) }
      user.articles
    end
    let(:mailer) { described_class.notify_author_of_staleness(articles) }

    subject { mailer }

    it { should send_email_to(email: user.email) }
    it { should use_template('Stale Article Alert') }
    it { should have_subject('Some of your Orientation articles might be stale') }
    # If the slug for all artuckes are in the email, it's a safe bet the full URLs are as well.
    it { articles.each { |article| should include_merge_var_content(article.slug) } }
    it { should include_merge_var_content(articles.second.slug) }
    it { should include_merge_var_content(articles.third.slug) }
    it { should be_from(email: 'orientation@codeschool.com') }
  end

  context ".send_updates_for(article, user)" do
    let(:article) { create(:article) }
    let(:mailer) { described_class.send_updates_for(article, user) }

    subject { mailer }

    it { should send_email_to(email: user.email) }
    it { should use_template('Article Subscription Update') }
    it { should have_subject('Article Subscription Update') }
    it { should be_from(email: 'orientation@codeschool.com') }
  end

  context ".send_rotten_notification_for(article, contributors)" do
    let(:article) { create(:article) }
    let(:contributors) do
      [article.author, article.editor].compact.map do |user|
        { name: user.name, email: user.email }
      end
    end

    let(:mailer) { described_class.send_rotten_notification_for(article, contributors) }

    subject { mailer }

    it { should send_email_to(email: contributors.first[:email]) }
    it { should use_template('Article Rotten Update') }
    it { should have_subject('Article Rotten Update') }
    it { should be_from(email: 'orientation@codeschool.com') }
  end

end
