# Public: This mailer sends a stale article alert email through
#           Mandrill instead of a normal action mailer email.
#
# article - a stale article (an article that has not been updated for several months)
#
# This email can be tested using the `.test` method:
#   ArticleMailer.test(:send_staleness_notification_for, email: <author.email>)
#
class ArticleMailer < MandrillMailer::TemplateMailer
  include ActionView::Helpers::UrlHelper

  default from: ENV['DEFAULT_FROM_EMAIL'] || 'notifications@orientation.io'

  def send_staleness_notification_for(articles)
    author = articles.last.author
    mandrill_mail template: 'stale-article-alert',
                  subject: 'Some of your Orientation articles might be stale',
                  from_name: ENV['DEFAULT_FROM_NAME'] || 'Orientation',
                  to: { email: author.email, name: author.name },
                  vars: {
                    'CONTENT' => format_email_content(articles)
                  }
  end

  def send_updates_for(article, user)
    mandrill_mail template: 'article-subscription-update',
                  subject: "#{article.title} was updated by #{article.editor}",
                  from_name: ENV['DEFAULT_FROM_NAME'] || 'Orientation',
                  to: { email: user.email, name: user.name },
                  vars: {
                    'ARTICLE_TITLE' => article.title,
                    'URL' => article_url(article),
                    'EDITOR' => article.editor
                  }
  end

  def send_outdated_notification_for(article, contributors, reporter)
    mandrill_mail template: 'article-outdated-update',
                  subject: "#{reporter.name} marked #{article.title} as outdated",
                  from_name: ENV['DEFAULT_FROM_NAME'] || 'Orientation',
                  to: contributors,
                  vars: {
                    'ARTICLE_TITLE' => article.title,
                    'URL' => article_url(article),
                    'REPORTER_NAME' => reporter.name,
                    'REPORTER_URL' => author_url(reporter)
                  }
  end

  def send_endorsement_notification_for(article, contributors, endorser)
    mandrill_mail template: 'article-endorsement-notification',
                  subject: "#{endorser.name} found #{article.title} useful!",
                  from_name: ENV['DEFAULT_FROM_NAME'] || 'Orientation',
                  to: format_contributors(contributors),
                  vars: {
                    'ENDORSER_NAME' => endorser.name,
                    'ENDORSER_URL' => author_url(endorser),
                    'ARTICLE_TITLE' => article.title,
                    'URL' => article_url(article)
                  }
  end

  private

  def format_contributors(contributors)
    contributors.map do |contributor|
      { name: contributor.name, email: contributor.email }
    end
  end

  def format_email_content(articles)
    articles.map do |article|
      content_tag(:li, link_to(article.title, article_url(article)))
    end.join
  end


  test_setup_for :send_staleness_notification_for do |mailer, options|
    articles = [
      MandrillMailer::Mock.new({
        id: 1,
        title: 'Test',
        author: MandrillMailer::Mock.new({
          email: options[:email]
        })
      })
    ]

    mailer.send_staleness_notification_for(articles).deliver
  end
end
