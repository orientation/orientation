class ArticleOutdatedWorker
  include Sidekiq::Worker

  def perform(article_id, reporter_id)
    article = Article.includes(:editor, :author).find(article_id)
    contributors = article.contributors
    reporter = User.find(reporter_id)

    ArticleMailer.send_outdated_notification_for(
      article, contributors, reporter
    ).deliver
  end
end
