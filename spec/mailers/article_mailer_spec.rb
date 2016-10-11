require "rails_helper"

RSpec.xdescribe ArticleMailer do
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
    it { is_expected.to have_subject('Some of your Wiki articles might be stale') }
    # If the slug for all artuckes are in the email, it's a safe bet the full URLs are as well.
    it { articles.each { |article| is_expected.to include_merge_var_content(article.slug) } }
    it { is_expected.to include_merge_var_content(articles.second.slug) }
    it { is_expected.to include_merge_var_content(articles.third.slug) }
    it { is_expected.to be_from(email: 'ops@doximity.com') }
  end

  context ".notify_author_of_rotten" do
    let(:articles) do
      2.times { create(:article, :rotten, author: user) }
      user.articles
    end

    let(:mailer) { described_class.notify_author_of_rotten(articles) }

    subject { mailer }

    it { is_expected.to send_email_to(email: user.email) }
    it { is_expected.to use_template('rotten-article-alert') }
    it { is_expected.to have_subject('Some of your Wiki articles have been marked as rotten') }
    # If the slug for all artuckes are in the email, it's a safe bet the full URLs are as well.
    it { articles.each { |article| is_expected.to include_merge_var_content(article.slug) } }
    it { is_expected.to include_merge_var_content(articles.second.slug) }
    it { is_expected.to be_from(email: 'ops@doximity.com') }
  end

  context ".send_updates_for(article, user, editor)" do
    let(:article) { create(:article, title: 'title', content: 'foo bar bjork baz') }
    let(:other_user) { create(:user) }
    let(:mailer) { described_class.send_updates_for(article, user) }

    before do
      article.editor = other_user
      article.reload
    end

    subject { mailer }

    it { is_expected.to send_email_to(email: user.email) }
    it { is_expected.to use_template('article-subscription-update') }
    it { is_expected.to have_subject("#{article.title} was updated by #{article.editor}") }
    it { is_expected.to be_from(email: 'ops@doximity.com') }
    it { is_expected.to have_merge_data('ARTICLE_TITLE' => article.title) }
    it { is_expected.to have_merge_data('URL' => article_url(article)) }
    it { is_expected.to have_merge_data('CHANGE_SUMMARY_HTML' => 'No changes to title or content.') }

    context 'article content updated' do
      before do
        article.update(content: 'foo bar Tim baz')
      end

      it 'contains the most recent change saved' do
        expect(subject).to have_merge_data('CHANGE_SUMMARY_HTML' =>
          %Q{<p>foo bar <del class=\"diffmod\">bjork</del><ins class=\"diffmod\">Tim</ins> baz</p>\n})
      end

      context 'updated twice before communicating change' do
        before do
          article.update(content: 'foo Tim baz',
                         change_last_communicated_at: 10.days.ago)
        end

        it 'contains all changes not communicated' do
          expect(subject).to have_merge_data('CHANGE_SUMMARY_HTML' =>
            %Q{<p>foo <del class="diffmod">bar bjork</del><ins class="diffmod">Tim</ins> baz</p>\n})
        end
      end
    end

    context 'article title updated' do
      before do
        article.update(title: "Tim's title")
      end
      it 'contains the most recent change saved' do
        expect(subject).to have_merge_data('CHANGE_SUMMARY_HTML' =>
          %q{<ins class="diffins">Tim's </ins>title})
      end
    end
  end

  context ".send_rotten_notification_for(article, contributors)" do
    let(:article) { create(:article) }
    let(:contributors) do
      [article.author, article.editor].compact.map do |user|
        { name: user.name, email: user.email }
      end
    end
    let(:reporter) { create(:user) }

    let(:mailer) { described_class.send_rotten_notification_for(article, contributors, reporter) }

    subject { mailer }

    it { is_expected.to send_email_to(email: contributors.first[:email]) }
    it { is_expected.to use_template('article-rotten-update') }
    it { is_expected.to have_subject("#{reporter.name} marked #{article.title} as rotten") }
    it { is_expected.to be_from(email: 'ops@doximity.com') }
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
    it { is_expected.to be_from(email: 'ops@doximity.com') }
  end

end
