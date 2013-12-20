desc "Notify Article Author when article is stale"

task notify_of_staleness: :environment do
	authors = Article.all.map(&:author)
	authors.each do |author|
		author.notify_of_article_staleness
	end
end
