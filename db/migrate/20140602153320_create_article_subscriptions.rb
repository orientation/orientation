class CreateArticleSubscriptions < ActiveRecord::Migration[4.2]
  def change
    create_table :article_subscriptions do |t|
      t.belongs_to :article
      t.belongs_to :user
      t.timestamps
    end
  end
end
