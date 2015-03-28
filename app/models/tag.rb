class Tag < ActiveRecord::Base
  has_and_belongs_to_many :articles, -> { uniq }, counter_cache: :tags_count, before_add: :validates_article

  after_create :increment_articles_counter
  before_destroy :decrement_articles_counter

  validates :name, uniqueness: true

  def to_s
    name
  end

  def self.tokens(query)
    tags = where("name ILIKE ?", "%#{query}%")
    if tags.empty?
      [{id: "<<<#{query}>>>", name: "New: \"#{query}\""}]
    else
      tags.collect{ |t| Hash["id" => t.id, "name" => t.name] }
    end
  end

  def self.ids_from_tokens(tokens)
    tokens.gsub!(/<<<(.+?)>>>/) { create!(name: $1).id }
    tokens.split(',')
  end

  def self.by_article_count
    all.sort_by { |tag| tag.articles.size }.reverse
  end

  def self.reset_articles_count
    self.all.each do |tag|
      article_count = tag.articles.count
      tag.update_attribute(:articles_count, article_count)
    end
  end

  private

  def validates_article(article)
    self.articles.include?(article)
  end

  def increment_articles_counter
    self.articles.each do |article|
      article.increment!(:tags_count)
    end
  end

  ## I haven't tested the callback on this, but it should work. What I am not 100% sure of is if the record is saved even
  ## a destroy, such that we can call `self.articles` on that same record and it works. If it doesn't work, then this can just
  ## be moved to a 'before_destroy'.

  def decrement_articles_counter
    self.articles.each do |article|
      article.decrement!(:tags_count)
    end
  end
end
