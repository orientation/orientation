class AddSubscriptionsCountToArticles < ActiveRecord::Migration[4.2]
  class MigrationArticleSubscription < ActiveRecord::Base
    self.table_name = "article_subscriptions"
    belongs_to :article, class_name: "MigrationArticle", foreign_key: "article_id"
  end

  class MigrationArticle < ActiveRecord::Base
    self.table_name = "articles"
    has_many :subscriptions, class_name: "MigrationArticleSubscription", foreign_key: "article_id"
  end

  def change
    add_column :articles, :subscriptions_count, :integer, default: 0

    MigrationArticle.find_each do |article|
      article.update_attribute(:subscriptions_count, article.subscriptions.count)
    end
  end
end
