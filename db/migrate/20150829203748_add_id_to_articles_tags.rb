class AddIdToArticlesTags < ActiveRecord::Migration[4.2]
  def change
    add_column :articles_tags, :id, :primary_key
  end
end
