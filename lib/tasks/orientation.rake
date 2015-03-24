namespace :orientation do
  desc "Install a fresh new Orientation"
  task :install do
    cp '.env.example', '.env'
    cp 'config/database.example.yml', 'config/database.yml'
    puts "You should now configure .env with your local database settings..."
    puts "Once you're done, run `rake db:create db:setup`."
  end
end
