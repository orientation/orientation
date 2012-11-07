class AddSlugToArticles < ActiveRecord::Migration
  def change
    add_column :articles, :slug, :string

    add_index :articles, :slug, unique: true
  end
end
