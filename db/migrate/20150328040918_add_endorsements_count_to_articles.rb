class AddEndorsementsCountToArticles < ActiveRecord::Migration[4.2]
  class MigrationArticleEndorsement < ActiveRecord::Base
    self.table_name = "article_endorsements"
    belongs_to :article, class_name: "MigrationArticle", foreign_key: "article_id"
  end

  class MigrationArticle < ActiveRecord::Base
    self.table_name = "articles"
    has_many :endorsements, class_name: "MigrationArticleEndorsement", foreign_key: "article_id"
  end

  def change
    add_column :articles, :endorsements_count, :integer, default: 0

    MigrationArticle.find_each do |article|
      article.update_attribute(:endorsements_count, article.endorsements.count)
    end
  end
end
