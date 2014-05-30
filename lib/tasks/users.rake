desc "Notify Article Authors when articles are stale"
task notify_of_staleness: :environment do
  User.author.to_a.each do |author|
    author.notify_about_stale_articles
  end
end

desc "Every Monday, send an email update to users who have subscribed to an article"
task send_article_subscription_update: :environment do
  if Time.now.monday?
    Article.fresh.each do |article|
      ArticleSubscriber.send_updates_for(article)
    end
  end
end

desc "Not those Blue People"
task recreate_avatars: :environment do
  User.all.each do |u| 
    begin
      u.avatar.cache_stored_file! 
      u.avatar.retrieve_from_cache!(u.avatar.cache_name) 
      u.avatar.recreate_versions! 
      u.save! 
    rescue => e
      puts  "ERROR: User: #{u.id} -> #{e.to_s}"
    end
  end
end
