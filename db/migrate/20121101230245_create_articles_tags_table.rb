class CreateArticlesTagsTable < ActiveRecord::Migration
  def change
    create_table :articles_tags, id: false do |t|
      t.references :article
      t.references :tag
    end

    add_index :articles_tags, [:article_id, :tag_id]
  end
end
