class ArticleDecorator < ApplicationDecorator
  delegate_all
  
  def author
    AuthorDecorator.new(source.author)
  end
end