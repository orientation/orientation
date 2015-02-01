class AddArticleIndices < ActiveRecord::Migration
  disable_ddl_transaction!

  def change
    add_index :articles, :archived_at, algorithm: :concurrently
  end
end
