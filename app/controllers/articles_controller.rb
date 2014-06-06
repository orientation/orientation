class ArticlesController < ApplicationController
  before_filter :authenticate!
  before_filter :find_article_by_params, only: [:show, :edit, :update, :destroy]
  before_filter :decorate_article, only: [:show, :edit, :toggle_archived, :toggle_subscription, :toggle_rotten]
  respond_to :html, :json

  def archived
    @archived_articles = ArticleDecorator.decorate_collection(Article.archived.includes(:tags))
  end

  def index
    @articles = ArticleDecorator.decorate_collection(Article.current.includes(:tags).text_search(params[:search]))
    @tags = Tag.by_article_count.take(10)
  end

  def show
    respond_with @article
  end

  def new
    @article = Article.new.decorate
  end

  def create
    @article = Article.new(article_params)
    redirect_to @article if @article.save
  end

  def edit
    @tags = @article.tags.collect{ |t| Hash["id" => t.id, "name" => t.name] }
  end

  def toggle_archived
    !@article.archived? ? @article.archive! : @article.unarchive!

    flash[:notice] = "Successfully #{@article.archived? ? "archived" : "unarchived"} this article."
    respond_with @article
  end

  def make_fresh
    @article = Article.find(params[:id])
    if @article.refresh!
      respond_with(@article)
    end
  end

  def toggle_rotten
    @article.rotten? @article.refresh! : @article.rot!
    flash[:notice] = "Successfully #{@article.rotten? ? "rotted" : "refreshed"} this article."
    respond_with(@article)
  end

  def update
    redirect_to @article if @article.update_attributes(article_params)
  end

  def destroy
    redirect_to articles_url if @article.destroy
  end

  def toggle_subscription
    if current_user.subscribed_to?(@article) 
      # TODO: improve this query
      current_user.subscriptions.where(article_id: @article.id).first.destroy
      flash[:notice] = "Subscription destroyed. You will no longer receive 
        weekly email notifications about this article."
    else
      current_user.subscriptions.create!(article_id: @article.id)
      flash[:notice] = "Subscription created. You will receive weekly email notifications 
        about this article."
    end
    
    respond_with @article
  end

  private

  def authenticate!
    authenticate_user! unless Rails.env.development?
  end

  def article_params
    params.require(:article).permit(:created_at, :updated_at, :title, :content, :tag_tokens, :author_id, :editor_id, :archived_at)
  end

  def decorate_article
    @article = ArticleDecorator.new(find_article_by_params)
  end

  def find_article_by_params
    @article ||= (Article.find_by_slug(params[:id]) or Article.find(params[:id]))
  end
  helper_method :article
end
