class ArticlesController < ApplicationController
  before_action :find_article_by_params, only: [
    :show,
    :edit,
    :update,
    :destroy
  ]
  before_action :decorate_article, only: [
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
    respond_with_article_or_redirect_or_new
    @article.count_visit if @article.present?
  end

  def new
    @article = Article.new(title: params[:title]).decorate
  end

  def create
    @article = Article.new(article_params)
    if @article.save
      @article.subscribe(@article.author)
      flash[:notice] = "Article was successfully created."
    else
      flash[:error] = error_message(@article)
    end
    respond_with @article
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
    respond_with_article_or_redirect
  end

  def mark_fresh
    if @article.refresh!
      respond_with_article_or_redirect
    end
  end

  def report_rot
    @article.rot!(current_user.id)
    flash[:notice] = "Successfully reported this article as rotten."
    respond_with_article_or_redirect
  end

  def update
    if @article.update_attributes(article_params)
      flash[:notice] = "Article was successfully updated."
    else
      flash[:error] = error_message(@article)
    end
    respond_with @article
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

    respond_with_article_or_redirect
  end

  def toggle_endorsement
    if !current_user.endorsing?(@article)
      @article.endorse_by(current_user)
      flash[:notice] = "Thanks for taking the time to make someone feel good about their work."
    else
      @article.unendorse_by(current_user)
      flash[:notice] = "Giving it, then taking it right back. Ruthless, aren't we?"
    end

    respond_with_article_or_redirect
  end

  def subscriptions
    @subscriptions = decorate_article.subscriptions.decorate
  end

  private

  def error_message(article)
    if article.errors.messages.key?(:friendly_id)
      "#{article.title} is a reserved word."
    else
      "Article could not be #{params[:action]}d."
    end
  end

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
    @article ||= begin
      Article.friendly.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      Article.friendly.none
    end
  end
  helper_method :article

  def respond_with_article_or_redirect_or_new
    if @article.present?
      respond_with_article_or_redirect
    else
      flash[:notice] = "Since this article doesn't exist, it would be super nice if you wrote it. :-)"
      redirect_to new_article_path(title: params[:id].titleize)
    end
  end

  def respond_with_article_or_redirect
    # If an old id or a numeric id was used to find the record, then
    # the request path will not match the post_path, and we should do
    # a 301 redirect that uses the current friendly id.

    if request.path != article_path(@article)
      return redirect_to @article, status: :moved_permanently
    else
      return respond_with @article
    end
  end
end
