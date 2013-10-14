class ArticlesController < ApplicationController
  before_filter :authenticate!
  before_filter :find_article_by_params, only: [:show, :edit, :update, :destroy]
  respond_to :html, :json

  def index
    @articles = ArticleDecorator.decorate_collection(Article.text_search(params[:search]))
    @tags = Tag.by_article_count.take(10)
  end

  def show
    respond_with @article = ArticleDecorator.new(find_article_by_params)
  end

  def new
    @article = Article.new.decorate
  end

  def create
    @article = Article.new(article_params)
    redirect_to @article if @article.save
  end

  def edit
    @article = ArticleDecorator.new(find_article_by_params)
    @tags = @article.tags.collect{ |t| Hash["id" => t.id, "name" => t.name] }
  end

  def make_fresh
    @article = Article.find(params[:id])
    if @article.touch(:updated_at)
      respond_with(@article)
    end
  end

  def update
    redirect_to @article if @article.update_attributes(article_params)
  end

  def destroy
    redirect_to articles_url if @article.destroy
  end

  private

  def authenticate!
    authenticate_user! unless Rails.env.development?
  end

  def article_params
    params.require(:article).permit(:created_at, :updated_at, :title, :content, :tag_tokens, :author_id, :editor_id)
  end

  def find_article_by_params
    @article ||= (Article.find_by_slug(params[:id]) or Article.find(params[:id]))
  end
  helper_method :article
end
