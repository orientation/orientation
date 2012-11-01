class Article < ActiveRecord::Base
  belongs_to :author, class_name: "User"
  has_and_belongs_to_many :tags

  def self.search(query)
    where("title ILIKE ?", "%#{query}%").order('title ASC')
  end
end