namespace :orientation do
  desc "Install a fresh new Orientation"
  task install: :environment do
    cp 'config/database.yml.example', 'config/database.yml'
    cp 'config/mandrill.yml.example', 'config/mandrill.yml'
    cp '.env.example', '.env'
    puts "You should now configure .env with your local database settings..."
    puts "Once you're done, run `rake db:create db:setup`."
  end
end
