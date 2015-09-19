class AddIdToArticlesTags < ActiveRecord::Migration
  def change
    add_column :articles_tags, :id, :primary_key
  end
end
