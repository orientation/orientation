class ArticleMailer < MandrillMailer::TemplateMailer
  include ActionView::Helpers::UrlHelper

  default from: 'orientation@codeschool.com'
  
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

  private

  def format_email_content(articles)
    articles.map do |article|
      content_tag(:li, link_to(article.title, article_url(article)))
    end.join
  end
end
