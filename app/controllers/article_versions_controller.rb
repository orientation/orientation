class ArticleVersionsController < ApplicationController
  before_action :find_article_by_params, only: [:index, :show, :update]
  before_action :set_paper_trail_whodunnit

  def index
    @versions = @article.versions.unscope(:order).order('created_at desc')
  end

  def show
    @version = @article.versions.find(params[:id])
    @article = ArticleDecorator.decorate(@version.reify)
    message = "Viewing version #{@version.id} #{@version.event}d " \
     "#{@version.created_at.to_s(:long_ordinal)}"
    if @version.whodunnit && user = User.find_by(id: @version.whodunnit)
      message += " by #{user}"
    end
    flash.now[:error] = message
    render template: 'articles/show'
  end

  def update
    @version = @article.versions.find(params[:id])
    @article = @version.reify
    @article.save
    redirect_to article_path(@article), notice: "Version restored."
  end

  private
  def find_article_by_params
    @article ||= begin
      Article.friendly.find(params[:article_id])
    rescue ActiveRecord::RecordNotFound
      Article.friendly.none
    end
  end
  helper_method :article
end
