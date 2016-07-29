# Public: This mailer sends a stale article alert email through
#           Mandrill instead of a normal action mailer email.
#
# article - a stale article (an article that has not been updated for several months)
#
# This email can be tested using the `.test` method:
#   ArticleMailer.test(:notify_author_of_staleness, email: <author.email>)
#
class ArticleMailer < ActionMailer::Base
  include ActionView::Helpers::UrlHelper
  include ApplicationHelper

  default from: ENV['DEFAULT_FROM_EMAIL'] || 'ops@doximity.com'


  def notify_author_of_staleness(articles)
    author = articles.last.author
    mandrill_mail template: 'stale-article-alert',
                  subject: 'Some of your Wiki articles might be stale',
                  from_name: ENV['DEFAULT_FROM_NAME'] || 'Dox Wiki',
                  to: { email: author.email, name: author.name },
                  vars: {
                    'CONTENT' => format_email_content(articles).html_safe
                  }
  end

  def notify_author_of_rotten(articles)
    author = articles.last.author
    mandrill_mail template: 'rotten-article-alert',
                  subject: 'Some of your Wiki articles have been marked as rotten',
                  from_name: ENV['DEFAULT_FROM_NAME'] || 'Dox Wiki',
                  to: { email: author.email, name: author.name },
                  vars: {
                    'CONTENT' => format_email_content(articles).html_safe
                  }
  end

  def send_updates_for(article, user)
    mandrill_mail template: 'article-subscription-update',
                  subject: "#{article.title} was just updated",
                  from_name: ENV['DEFAULT_FROM_NAME'] || 'Dox Wiki',
                  to: { email: user.email, name: user.name },
                  vars: {
                    'ARTICLE_TITLE' => article.title,
                    'URL' => article_url(article),
                    'CHANGE_SUMMARY_HTML' => change_summary_html(article)
                  }
  end

  def send_rotten_notification_for(article, contributors, reporter, description)
    mandrill_mail template: 'article-rotten-update',
                  subject: "#{reporter.name} marked #{article.title} as rotten",
                  from_name: 'Dox Wiki',
                  to: contributors,
                  vars: {
                    'ARTICLE_TITLE' => article.title,
                    'URL' => article_url(article),
                    'REPORTER_NAME' => reporter.name,
                    'REPORTER_URL' => author_url(reporter),
                    'DESCRIPTION' => description
                  }
  end

  def send_endorsement_notification_for(article, contributors, endorser)
    mandrill_mail template: 'article-endorsement-notification',
                  subject: "#{endorser.name} found #{article.title} useful!",
                  from_name: ENV['DEFAULT_FROM_NAME'] || 'Dox Wiki',
                  to: contributors,
                  vars: {
                    'ENDORSER_NAME' => endorser.name,
                    'ENDORSER_URL' => author_url(endorser),
                    'ARTICLE_TITLE' => article.title,
                    'URL' => article_url(article)
                  }
  end

  private

  # Orientation is meant to be used with mandril and this is a simple adapter to
  # ensure we keep the code above unchanged to avoid potential merge headaches
  # when bringing in upstream changes
  def mandrill_mail(mail_params)
    recipients = mail_params[:to].is_a?(Hash) ? [mail_params[:to]] : Array(mail_params[:to])
    mail_params[:to] = recipients.map { |to| %("#{to[:name]}" <#{to[:email]}>) }.join(', ')
    mail_params[:from] = %("#{mail_params.delete(:from_name)}" <#{ENV.fetch('DEFAULT_FROM_EMAIL', 'orientation@codeschool.com')}>)
    mail_params[:template_name] = mail_params.delete(:template).underscore
    @email_vars = mail_params.delete(:vars)
    mail(mail_params)
  end

  def change_summary_html(article)
    changes = format_changes_snippet(article)
    if changes.present?
      changes
    else
      'No changes to title or content.'
    end
  end

  def format_email_content(articles)
    articles.map do |article|
      content_tag(:li,
        link_to(article.title,
          Rails.application.routes.url_helpers.article_url(
            article, host: ENV.fetch("ORIENTATION_DOMAIN")
          )
        )
      )
    end.join
  end

  def format_changes_snippet(article)
    last_version = article.versions
    last_version = last_version.where(PaperTrail::Version.arel_table[:created_at].gteq(article.change_last_communicated_at))
      .reorder(created_at: :desc) if article.change_last_communicated_at
    last_version = last_version.last.try(:reify)
    if last_version
      formatted_changes(last_version.title, article.title) +
        formatted_changes(markdown(last_version.content), markdown(article.content))
    end
  end

  def formatted_changes(last_value, article_value)
    if last_value != article_value
      HTMLDiffTool.diff(last_value, article_value)
    else
      ''
    end
  end

  # test_setup_for :notify_author_of_staleness do |mailer, options|
  #   articles = [
  #     MandrillMailer::Mock.new({
  #       id: 1,
  #       title: 'Test',
  #       author: MandrillMailer::Mock.new({
  #         email: options[:email]
  #       })
  #     })
  #   ]

  #   mailer.notify_author_of_staleness(articles).deliver
  # end
end
