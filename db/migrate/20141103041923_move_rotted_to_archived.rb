class MoveRottedToArchived < ActiveRecord::Migration
  def up
    execute("UPDATE articles SET archived_at = rotted_at WHERE archived_at IS NULL AND rotted_at IS NOT NULL;")
    remove_column :articles, :rotted_at
  end
end
