class CreateArticleEndorsements < ActiveRecord::Migration[4.2]
  def change
    create_table :article_endorsements do |t|
      t.integer :user_id
      t.integer :article_id

      t.timestamps
    end
  end
end
