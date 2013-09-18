class ArticleMailer < ActionMailer::Base
	default from: 'support@codeschool.com'
	
	def notify_author_of_staleness(article)
		@article = article
		@author = article.author
		mail(to: @author.email, subject: "Stale Article Alert", author: @author, article: @article)
	end

end