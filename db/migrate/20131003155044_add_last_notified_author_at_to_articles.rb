class AddLastNotifiedAuthorAtToArticles < ActiveRecord::Migration[4.2]
  def change
  	add_column :articles, :last_notified_author_at, :datetime
  end
end
