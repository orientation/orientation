class CreateArticleViews < ActiveRecord::Migration[5.0]
  def change
    create_table :article_views do |t|
      t.belongs_to :article, null: false
      t.belongs_to :user, null: false

      t.timestamps
    end
  end
end
