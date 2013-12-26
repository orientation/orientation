class Tag < ActiveRecord::Base
  has_and_belongs_to_many :articles

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
end
