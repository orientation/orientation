class ArticleSubscriber

	def initialize(article, user)
		@article = article
		@user = user
	end

	def subscribe
		@article.subscribed_users << @user
		@article.save!
	end

	def unsubscribe
		@user.article_subscription_id = nil
		@user.save!
	end

	private

	def self.send_updates_for(article)
		article.subscribed_users.each do |user|
			SendArticleUpdateJob.enqueue(article.id, user.id)
		end
	end

end