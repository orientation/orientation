class AddGuideBooleanToArticles < ActiveRecord::Migration
  def change
    add_column :articles, :guide, :boolean, default: false
  end
end
