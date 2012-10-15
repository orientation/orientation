class ArticlesController < ApplicationController
  def index
    @articles = Article.all
  end

  def show
    @article = find_article_by_params
  end

  def new
    @article = Article.new
  end

  def create
    redirect_to @article if @article = Article.create(article_params)
  end

  def edit
    @article = find_article_by_params
  end

  def update
    @article = find_article_by_params
    redirect_to @article if @article.update_attributes(article_params)
  end

  def destroy
    @article = find_article_by_params
    redirect_to articles_url if @article.destroy  
  end

  private

  def article_params
    params.require(:article).permit(:title, :content)    
  end

  def find_article_by_params
    Article.find(params[:id])
  end
end
