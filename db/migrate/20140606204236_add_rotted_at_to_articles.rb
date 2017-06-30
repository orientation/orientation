class AddRottedAtToArticles < ActiveRecord::Migration[4.2]
  def change
    add_column :articles, :rotted_at, :datetime
  end
end
