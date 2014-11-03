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
