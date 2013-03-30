class CreateRevisions < ActiveRecord::Migration
  def change
    create_table :revisions do |t|
      t.integer :editor_id
      t.text :content
      t.integer :article_id

      t.timestamps
    end
  end
end
