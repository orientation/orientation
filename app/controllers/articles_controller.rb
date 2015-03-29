class ArticlesController < ApplicationController
  before_filter :find_article_by_params, only: [:show, :edit, :update, :destroy]
  before_filter :decorate_article, only: [
    :show,
    :edit,
    :toggle_archived,
    :toggle_subscription,
    :toggle_endorsement,
    :report_rot,
    :mark_fresh
  ]
  respond_to :html, :json

  def index
    @articles = fetch_articles
  end

  def show
    @article.count_visit
    respond_with @article
  end

  def new
    @article = Article.new(title: params[:title]).decorate
  end

  def create
    @article = Article.new(article_params)
    redirect_to article_path(@article) if @article.save
  end

  def edit
    @tags = @article.tags.collect{ |t| Hash["id" => t.id, "name" => t.name] }
  end

  def fresh
    @articles = fetch_articles(Article.current.fresh)
    @page_title = "Fresh Articles"
    render :index
  end

  def stale
    @articles = fetch_articles(Article.current.stale)
    @page_title = "Stale Articles"
    render :index
  end

  def rotten
    @articles = fetch_articles(Article.current.rotten)
    @page_title = "Rotten Articles"
    render :index
  end

  def archived
    @articles = fetch_articles(Article.archived)
    @page_title = "Archived Articles"
    render :index
  end

  def popular
    @articles = fetch_articles(Article.current.popular)
    @page_title = "Popular Articles"
    render :index
  end

  def toggle_archived
    !@article.archived? ? @article.archive! : @article.unarchive!

    flash[:notice] = "Successfully #{@article.archived? ? "archived" : "unarchived"} this article."
    respond_with @article
  end

  def mark_fresh
    if @article.refresh!
      respond_with(@article)
    end
  end

  def report_rot
    @article.rot!
    flash[:notice] = "Successfully reported this article as rotten."
    respond_with @article
  end

  def update
    redirect_to article_path(@article) if @article.update_attributes(article_params)
  end

  def destroy
    redirect_to articles_url if @article.destroy
  end

  def toggle_subscription
    if !current_user.subscribed_to?(@article)
      @article.subscribe(current_user)
      flash[:notice] = "You will now receive email notifications when this article is updated."
    else
      @article.unsubscribe(current_user)
      flash[:notice] = "You will no longer receive email notifications when this article is updated."
    end

    respond_with @article
  end

  def toggle_endorsement
    if !current_user.endorsing?(@article)
      @article.endorse_by(current_user)
      flash[:notice] = "Thanks for taking the time to make someone feel good about their work."
    else
      @article.unendorse_by(current_user)
      flash[:notice] = "Giving it, and taking it right back. Ruthless, aren't we?"
    end

    respond_with @article
  end

  def subscriptions
    @subscriptions = decorate_article.subscriptions.decorate
  end

  private

  def article_params
    params.require(:article).permit(
      :created_at, :updated_at, :title, :content, :tag_tokens,
      :author_id, :editor_id, :archived_at, :guide)
  end

  def decorate_article
    @article = ArticleDecorator.new(find_article_by_params)
  end

  def fetch_articles(scope = nil)
    scope ||= Article.current
    query = Article.includes(:tags).text_search(params[:search], scope)
    ArticleDecorator.decorate_collection(query)
  end

  def find_article_by_params
    @article ||= (Article.find_by_slug(params[:id]) or Article.find(params[:id]))
  end
  helper_method :article
end
