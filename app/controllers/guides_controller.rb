class GuidesController < ApplicationController
  def index
    @guides = ArticleDecorator.decorate_collection(Article.guide)
    @articles = ArticleDecorator.decorate_collection(Article.current)
    redirect_to(articles_path) if @guides.empty?
  end

  def show
    @article
  end

  private

  def find_article_by_params
    @article ||= (Article.guide.find_by_slug(params[:id]) or Article.guide.find(params[:id]))
  end
end
