class NotifyAuthorOfStalenessJob < Struct.new(:article_id)
	def perform
		article = Article.find(article_id)
		article.last_notified_author_at = Date.today
		article.save
		ArticleMailer.notify_author_of_staleness(article).deliver
	end
end