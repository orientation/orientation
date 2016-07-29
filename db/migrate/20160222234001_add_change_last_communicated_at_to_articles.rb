class AddChangeLastCommunicatedAtToArticles < ActiveRecord::Migration
  def change
    add_column :articles, :change_last_communicated_at, :datetime
  end
end
