desc "Notify Article Authors when articles are stale"

task notify_of_staleness: :environment do
  User.author.to_a.each do |author|
    author.notify_about_stale_articles
  end
end

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
