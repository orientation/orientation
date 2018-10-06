require 'securerandom'

namespace :orientation do
  desc "Install a fresh new Orientation on your machine"
  task :install do
    puts "Installing Orientation..."
    system 'bundle install'
    cp '.env.example', '.env'
    cp 'config/database.sample.yml', 'config/database.yml'
    puts "You should now configure .env with your local database settings..."
    puts "Use the following value for the `SECRET_KEY_BASE` key:"
    puts SecureRandom.hex(64)
    puts "Make sure you also set the `DATABASE_USERNAME` and `DATABASE_PASSWORD` keys"
    puts "Once you're done, run `rake db:create db:setup`."

    yarn_installed = system 'which yarn'

    if yarn_installed
      system "yarn install"
    else
      puts "You don't seem to have yarn installed."
      puts "You can install yarn by installing Node.js: https://nodejs.org/"
      puts "I'm sorry if this is a bit tedious."
      puts "Once you have yarn installed, all you'll have to do is run:"
      puts "yarn install"
    end
  end

  desc "Migrate old slugs to versioned slugs"
  task migrate_slugs: :environment do
    puts "Generating versioned slugs..."
    Article.all.each(&:save!)
  end
end
