desc "Notify Article Authors when articles are stale"
task notify_of_staleness: :environment do
  User.author.to_a.each do |author|
    author.notify_about_stale_articles
  end
end

desc "Make all user emails private"
task make_all_emails_private: :environment do
  User.find_each do |u|
    u.update(private_email: true)
  end
end
