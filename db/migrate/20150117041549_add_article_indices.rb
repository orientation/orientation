class AddArticleIndices < ActiveRecord::Migration[4.2]
  disable_ddl_transaction!

  def change
    add_index :articles, :archived_at, algorithm: :concurrently
  end
end
