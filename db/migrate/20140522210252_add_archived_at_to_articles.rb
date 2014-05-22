class AddArchivedAtToArticles < ActiveRecord::Migration
  def change
    add_column :articles, :archived_at, :timestamp
  end
end
