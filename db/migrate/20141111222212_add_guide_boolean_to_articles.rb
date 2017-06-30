class AddGuideBooleanToArticles < ActiveRecord::Migration[4.2]
  def change
    add_column :articles, :guide, :boolean, default: false
  end
end
