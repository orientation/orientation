class AddEditorIdToArticles < ActiveRecord::Migration[4.2]
  def change
    add_column :articles, :editor_id, :integer
  end
end
