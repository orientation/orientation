class ArticlesController < ApplicationController
  def index
    @articles = Article.all
  end

  def show
    @article = Article.find(params[:id])
  end

  def new
    @article = Article.new
  end

  def create
    @article = Article.new(article_params)
    if @article.save
      redirect_to @article
    else
      flash[:error] = "Could not create Article."
      render :new
    end
  end

  private

  def article_params
    params.require(:article).permit(:title, :content)    
  end
end
