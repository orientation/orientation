class Article < ActiveRecord::Base
  extend FriendlyId

  belongs_to :author, class_name: "User"
  has_and_belongs_to_many :tags

  attr_reader :tag_tokens

  friendly_id :title, use: :slugged

  def self.search(query)
    where("title ILIKE ?", "%#{query}%").order('title ASC')
  end

  def tag_tokens=(tokens)
    self.tag_ids = Tag.ids_from_tokens(tokens)
  end

  def to_s
    title
  end
end