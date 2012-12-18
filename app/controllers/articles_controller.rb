class ArticlesController < ApplicationController
  before_filter :authenticate_user!, except: [:index]
  before_filter :find_article_by_params, only: [:show, :edit, :update, :destroy]
  respond_to :html, :json

  def index
    @articles = Article.search(params[:search])
  end

  def show
    respond_with @article = ArticleDecorator.new(find_article_by_params)
  end

  def new
    @article = Article.new
  end

  def create
    @article.author = current_user
    redirect_to @article if @article.save
  end

  def edit
    @tags = @article.tags.collect{ |t| Hash["id" => t.id, "name" => t.name] }
  end

  def update
    @article.author = @article.author || current_user
    redirect_to @article if @article.update_attributes(article_params)
  end

  def destroy
    redirect_to articles_url if @article.destroy
  end

  private

  def article_params
    params.require(:article).permit(:title, :content, :tag_tokens)
  end

  def find_article_by_params
    @article ||= (Article.find_by_slug(params[:id]) or Article.find(params[:id]))
  end
  helper_method :article
end
