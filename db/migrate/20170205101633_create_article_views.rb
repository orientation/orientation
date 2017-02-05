class CreateArticleViews < ActiveRecord::Migration[5.0]
  def change
    create_table :article_views do |t|
      t.belongs_to :article 
      t.belongs_to :user

      t.timestamps
    end
  end
end
