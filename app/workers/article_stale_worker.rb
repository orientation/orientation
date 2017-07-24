class ArticleStaleWorker
  include Sidekiq::Worker

  def perform(article_ids)
    articles = Article.find(article_ids)
    articles.each do |article|
      article.update_column(:last_notified_author_at, Date.today)
    end

    ArticleMailer.send_staleness_notification_for(articles).deliver
  end
end
