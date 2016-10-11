class Tag < ApplicationRecord
  extend FriendlyId

  has_many :articles_tags, dependent: :destroy
  has_many :articles, through: :articles_tags, counter_cache: :articles_count

  validates :name, uniqueness: { case_sensitive: false }

  friendly_id :name

  def to_s
    name
  end

  def to_param
    slug
  end

  def self.tokens(query)
    tags = where(%Q["tags"."name" ILIKE ?], "%#{query}%")
    new_tag = {id: "<<<#{query}>>>", name: "New: \"#{query}\""}
    if tags.empty?
      [new_tag]
    else
      results = tags.collect{ |t| Hash["id" => t.id, "name" => t.name] }
      results.unshift(new_tag) if tags.select{|t| t.name.downcase == query.downcase}.empty?
      results
    end
  end

  def self.ids_from_tokens(tokens)
    tokens.gsub!(/<<<(.+?)>>>/) { create!(name: $1).id }
    tokens.split(',')
  end

  def self.by_article_count
    order(articles_count: :desc)
  end

  def self.reset_articles_count
    pluck(:id).each do |tag_id|
      reset_counters(tag_id, :articles)
    end
  end
end
