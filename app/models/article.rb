class Article < ActiveRecord::Base
  belongs_to :author, class_name: "User"

  def self.search(query)
    where("title ILIKE ?", "%#{query}%").order('title ASC')
  end
end