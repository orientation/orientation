class NotifyAuthorOfStalenessJob < Struct.new(:article_id)
	def perform
		article = Article.find(article_id)
		article.update_column(:last_notified_author_at, Date.today)
		ArticleMailer.notify_author_of_staleness(article).deliver
	end
end