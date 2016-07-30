class ArticlesTag < ApplicationRecord
  belongs_to :article, counter_cache: :tags_count
  belongs_to :tag, counter_cache: :articles_count

  validates :article_id, uniqueness: { scope: :tag_id, case_sensitive: false }
end
