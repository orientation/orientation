class AddVisitsToArticles < ActiveRecord::Migration[4.2]
  def change
    add_column :articles, :visits, :integer, default: 0, null: false
  end
end
