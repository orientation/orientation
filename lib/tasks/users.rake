desc "Notify Article Authors when articles are stale"
task notify_of_staleness: :environment do
  User.author.to_a.each do |author|
    author.notify_about_stale_articles
  end
end
