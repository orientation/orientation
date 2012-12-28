class AddEditorIdToArticles < ActiveRecord::Migration
  def change
    add_column :articles, :editor_id, :integer
  end
end
