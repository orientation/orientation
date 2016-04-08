# Public: This mailer sends a stale article alert email through
#           Mandrill instead of a normal action mailer email.
#
# article - a stale article (an article that has not been updated for several months)
#
# This email can be tested using the `.test` method:
#   ArticleMailer.test(:notify_author_of_staleness, email: <author.email>)
#
class ArticleMailer < MandrillMailer::TemplateMailer
  include ActionView::Helpers::UrlHelper

  default from: 'orientation@codeschool.com'

  def notify_author_of_staleness(articles)
    author = articles.last.author
    mandrill_mail template: 'stale-article-alert',
                  subject: 'Some of your Orientation articles might be stale',
                  from_name: 'Orientation',
                  to: { email: author.email, name: author.name },
                  vars: {
                    'CONTENT' => format_email_content(articles)
                  }
  end

  def send_updates_for(article, user)
    mandrill_mail template: 'article-subscription-update',
                  subject: "#{article.title} was updated by #{article.editor}",
                  from_name: 'Orientation',
                  to: { email: user.email, name: user.name },
                  vars: {
                    'ARTICLE_TITLE' => article.title,
                    'URL' => article_url(article),
                    'EDITOR' => article.editor
                  }
  end

  def send_rotten_notification_for(article, contributors, reporter)
    mandrill_mail template: 'article-rotten-update',
                  subject: "#{reporter.name} marked #{article.title} as rotten",
                  from_name: 'Orientation',
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
                  from_name: 'Orientation',
                  to: contributors,
                  vars: {
                    'ENDORSER_NAME' => endorser.name,
                    'ENDORSER_URL' => author_url(endorser),
                    'ARTICLE_TITLE' => article.title,
                    'URL' => article_url(article)
                  }
  end

  private

  def format_email_content(articles)
    articles.map do |article|
      content_tag(:li, link_to(article.title, article_url(article)))
    end.join
  end


  test_setup_for :notify_author_of_staleness do |mailer, options|
    articles = [
      MandrillMailer::Mock.new({
        id: 1,
        title: 'Test',
        author: MandrillMailer::Mock.new({
          email: options[:email]
        })
      })
    ]

    mailer.notify_author_of_staleness(articles).deliver
  end
end
