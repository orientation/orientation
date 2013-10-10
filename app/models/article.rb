class Article < ActiveRecord::Base
  belongs_to :author, class_name: "User"
  belongs_to :editor, class_name: "User"
  has_and_belongs_to_many :tags

  attr_reader :tag_tokens

  before_validation :generate_slug

  validates :slug, uniqueness: true, presence: true

  def self.fresh
    where("updated_at >= ?", 7.days.ago)
  end

  def self.fresh?(article)
    self.fresh.include?(article)
  end

  def self.stale
    where("updated_at < ?", 6.months.ago)
  end

  def self.stale?(article)
    self.stale.include?(article)
  end

  def self.text_search(query)
    if query.present?
      where("title ILIKE :q OR content ILIKE :q", q: "%#{query}%").order('title ASC')
    else
      order(updated_at: :desc)
    end 
  end

  def self.ordered_fresh
    all.order(updated_at: :desc).limit(20)
  end

  # an article is fresh when it has been created or updated 7 days ago
  # or more recently
  def fresh?
    Article.fresh? self
  end

  # an article is stale when it has been created over 4 months ago
  # and has never been updated since
  def stale?
    Article.stale? self
  end

  def tag_tokens=(tokens)
    self.tag_ids = Tag.ids_from_tokens(tokens)
  end

  def to_s
    title
  end

  def to_param
    slug
  end

  private

  def generate_slug
    self.slug ||= title.parameterize
  end
end