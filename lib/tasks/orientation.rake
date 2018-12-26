require 'securerandom'

namespace :orientation do
  desc "Migrate old slugs to versioned slugs"
  task migrate_slugs: :environment do
    puts "Generating versioned slugs..."
    Article.all.each(&:save!)
  end

  desc "Destroy all articles"
  task destroy_articles: :environment do
    raise "Don't do it!" if Rails.env.production?

    puts "Destroying all articles..."
    Article.destroy_all
  end
end
