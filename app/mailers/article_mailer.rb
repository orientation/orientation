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
    mandrill_mail template: 'Stale Article Alert',
                  subject: 'Some of your Orientation articles might be stale',
                  from_name: 'Code School',
                  to: { email: author.email, name: author.name },
                  vars: {
                    'CONTENT' => format_email_content(articles)
                  }
  end

  def send_updates_for(article, user)
    mandrill_mail template: 'Article Subscription Update',
                  subject: 'Article Subscription Update',
                  from_name: 'Code School', 
                  to: { email: user.email, name: user.name }, 
                  vars: {
                    'ARTICLE_TITLE' => article.title,
                    'URL' => article_url(article)
                  }
  end

  def send_rotten_notification_for(article, contributors)
    mandrill_mail template: 'Article Rotten Update',
                  subject: 'Article Rotten Update',
                  from_name: 'Code School', 
                  to: contributors, 
                  vars: {
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
