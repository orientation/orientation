class AddArchivedAtToArticles < ActiveRecord::Migration[4.2]
  def change
    add_column :articles, :archived_at, :timestamp
  end
end
