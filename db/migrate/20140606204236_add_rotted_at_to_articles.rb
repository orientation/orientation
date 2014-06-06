class AddRottedAtToArticles < ActiveRecord::Migration
  def change
    add_column :articles, :rotted_at, :datetime
  end
end
