require_dependency "article"

class Article::View < ActiveRecord::Base
  belongs_to :article
  belongs_to :user

  validates :article, presence: true
  validates :user, presence: true

  def increment_count
    increment(:count)
  end
end
