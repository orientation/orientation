require 'securerandom'

namespace :orientation do
  desc "Install a fresh new Orientation on your machine"
  task :install do
    puts "Installing Orientation..."
    system 'bundle install'
    cp '.env.example', '.env'
    cp 'config/database.example.yml', 'config/database.yml'
    puts "You should now configure .env with your local database settings..."
    puts "Use the following value for the `SECRET_KEY_BASE` key:"
    puts SecureRandom.hex(64)
    puts "Make sure you also set the `DATABASE_USERNAME` and `DATABASE_PASSWORD` keys"
    puts "Once you're done, run `rake db:create db:setup`."

    bower_installed = system 'which bower'

    if bower_installed
      system 'bower install'
    else
      npm_installed = system 'which npm'

      if npm_installed
        puts "You have npm installed, so you can install Bower with:"
        puts "npm install -g bower"
        puts "After that, just run `bower install` and you'll be good to go."
      else
        puts "You don't seem to have npm installed."
        brew_installed = system 'which brew'

        if brew_installed
          puts "You can install npm through Homebrew with:"
          puts "brew install npm"
        else
          puts "You can install npm by installing Node.js: https://nodejs.org/"
          puts "I'm sorry if this is a bit tedious."
          puts "Once you have npm installed, all you'll have to do is run:"
          puts "npm install -g bower && bower install"
        end
      end
    end
  end

  desc "Migrate old slugs to versioned slugs"
  task migrate_slugs: :environment do
    puts "Generating versioned slugs..."
    Article.all.each(&:save!)
  end
end
