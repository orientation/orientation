class AddCountToArticleViews < ActiveRecord::Migration[5.0]
  def change
    add_column :article_views, :count, :integer, default: 1
  end
end
