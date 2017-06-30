class AddSearchIndexToArticles < ActiveRecord::Migration[4.2]
  def up
    execute "create index articles_title on articles using gin(to_tsvector('english', title))"
    execute "create index articles_content on articles using gin(to_tsvector('english', content))"
  end

  def down
    execute "drop index articles_title"
    execute "drop index articles_content"
  end
end
