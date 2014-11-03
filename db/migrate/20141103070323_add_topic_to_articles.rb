class AddTopicToArticles < ActiveRecord::Migration
  def change
    add_column :articles, :topic, :text
  end
end
