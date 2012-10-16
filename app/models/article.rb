class Article < ActiveRecord::Base
  belongs_to :author

  def self.search(query)
    if query
      self.where("title ILIKE ?", "%#{query}%")
    else
      self.all
    end
  end
end