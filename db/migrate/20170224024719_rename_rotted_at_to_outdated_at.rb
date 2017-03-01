class RenameRottedAtToOutdatedAt < ActiveRecord::Migration[5.0]
  def change
    rename_column :articles, :rotted_at, :outdated_at
  end
end
