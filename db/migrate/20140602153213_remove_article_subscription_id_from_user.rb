class RemoveArticleSubscriptionIdFromUser < ActiveRecord::Migration
  def change
    remove_column :users, :article_subscription_id
  end
end
