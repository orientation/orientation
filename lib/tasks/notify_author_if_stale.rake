desc "Notify Article Author when article is stale"

namespace :articles do
	task notify_author_if_stale: :environment do
		Article.stale.each do |article|
			article.notify_author_of_staleness
		end
	end
end