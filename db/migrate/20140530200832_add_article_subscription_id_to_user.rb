class AddArticleSubscriptionIdToUser < ActiveRecord::Migration
  def change
  	add_column :users, :article_subscription_id, :integer
  end
end
