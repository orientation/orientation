class AddLastNotifiedAuthorAtToArticles < ActiveRecord::Migration
  def change
  	add_column :articles, :last_notified_author_at, :datetime
  end
end
