class GuidesController < ApplicationController
  def index
    @guides = ArticleDecorator.decorate_collection(guides)

    redirect_to(articles_path) if @guides.empty?
  end

  private

  def guides
    Article.guide.current.alphabetical
  end

  def articles
    Article.includes(:tags).current
  end
end
