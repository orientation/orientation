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

  desc "Import articles from GitHub Wiki"
  task import_github_wiki: [:environment] do
    Dir.chdir(ENV["WIKI_PATH"]) do
      Dir.glob("*.md").sort.each do |file|
        # we don't want GitHub-specific layout articles
        next if file.starts_with?("_")

        title = file.sub(".md", "")

        # only remove dashes in titles we know can't be topic names which
        # often include dashes (-) as word separators, for example:
        #   ps.content-facts.facet-removed.v1
        #
        # See: https://regex101.com/r/jZdOd8/1
        unless title.match?(/ps\.([a-z-]*)\.([a-z-]*)\.(v[0-9])/)
          title = title.split("-").join(" ")
        end

        next if Article.find_by(title: title)

        # we need to find the creator of the file
        authors = %x[git blame "#{file}" --porcelain | grep  "^author " | uniq].split("\n").map { |st| st.sub("author ", "") }
        emails = %x[git blame "#{file}" --porcelain | grep  "^author-mail " | uniq].split("\n").map { |st| st.sub("author-mail ", "") }
        author = User.find_or_create_by(name: authors.first, email: emails.first.tr('<>', ''))
        editor = User.find_or_create_by(name: authors.last, email: emails.last.tr('<>', ''))

        dates = %x[git blame "#{file}" --porcelain | grep  "^author-time " | uniq].split("\n").map { |st| st.sub("author-time ", "") }
        creation_time = Time.at(dates.first.to_i)
        last_edit_time = Time.at(dates.last.to_i)

        a = Article.find_or_create_by(
          author: author,
          editor: editor,
          content: File.read(file),
          title: title
        )

        a.update(created_at: creation_time, updated_at: last_edit_time)

        puts "#{a.title} (#{a.created_at} - #{a.updated_at})"
      end
    end
  end
end
