class Article < ActiveRecord::Base
  belongs_to :author, class_name: "User"
  has_and_belongs_to_many :tags

  attr_reader :tag_tokens

  before_validation :generate_slug

  validates :slug, uniqueness: true, presence: true

  def self.search(query)
    where("title ILIKE ?", "%#{query}%").order('title ASC')
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