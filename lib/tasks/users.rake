desc "Notify Article Author when article is stale"

task notify_author_if_article_staleness: :environment do
	authors = Article.all.map(&:author)
	authors.each do |author|
		author.notify_if_article_staleness
	end
end
