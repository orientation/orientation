require 'spec_helper'

describe ArticleMailer do
  let(:user) { create(:user, email: 'aimee@hanso.dk') }

  context ".notify_author_of_staleness" do
    let(:articles) do
      3.times { create(:article, :stale, author: user) }
      user.articles
    end
    let(:mailer) { described_class.notify_author_of_staleness(articles) }

    subject { mailer }

    it { is_expected.to send_email_to(email: user.email) }
    it { is_expected.to use_template('stale-article-alert') }
    it { is_expected.to have_subject('Some of your Orientation articles might be stale') }
    # If the slug for all artuckes are in the email, it's a safe bet the full URLs are as well.
    it { articles.each { |article| is_expected.to include_merge_var_content(article.slug) } }
    it { is_expected.to include_merge_var_content(articles.second.slug) }
    it { is_expected.to include_merge_var_content(articles.third.slug) }
    it { is_expected.to be_from(email: 'orientation@codeschool.com') }
  end

  context ".send_updates_for(article, user)" do
    let(:article) { create(:article) }
    let(:mailer) { described_class.send_updates_for(article, user) }

    subject { mailer }

    it { is_expected.to send_email_to(email: user.email) }
    it { is_expected.to use_template('article-subscription-update') }
    it { is_expected.to have_subject("#{article.title} was just updated") }
    it { is_expected.to be_from(email: 'orientation@codeschool.com') }
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

    it { is_expected.to send_email_to(email: contributors.first[:email]) }
    it { is_expected.to use_template('article-rotten-update') }
    it { is_expected.to have_subject('Article Rotten Update') }
    it { is_expected.to be_from(email: 'orientation@codeschool.com') }
  end

  context ".send_endorsement_notification_for(article, author, endorser)" do
    let(:article) { create(:article) }
    let(:contributors) { article.contributors }
    let(:endorsement) { create(:article_endorsement, article: article) }
    let(:endorser) { endorsement.user }

    let(:mailer) { described_class.send_endorsement_notification_for(article, contributors, endorser) }

    subject { mailer }

    it { is_expected.to send_email_to(email: contributors.first[:email]) }
    it { is_expected.to use_template('article-endorsement-notification') }
    it { is_expected.to have_subject("#{endorser.name} found #{article.title} useful!") }
    it { is_expected.to be_from(email: 'orientation@codeschool.com') }
  end

end
