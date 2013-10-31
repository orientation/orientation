class NotifyAuthorOfStalenessJob < Struct.new(:articles)
	def perform
    # FIXME: this is broken, disabled until it isn't.
		# articles.map do |article|
		# 	article.update_column(:last_notified_author_at, Date.today)
		# end
		# ArticleMailer.notify_author_of_staleness(articles).deliver
	end
end