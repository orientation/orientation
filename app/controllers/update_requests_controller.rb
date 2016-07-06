class UpdateRequestsController < ApplicationController
  def new
    fetch_article
    @update_request = @article.update_requests.build
  end

  def create
    fetch_article
    @article.update_requests.create(update_request_params)
    respond_with @article
  end

  private
  def fetch_article
    @article = Article.friendly.find(params[:article_id])
  end

  def update_request_params
    params.require(:update_request)
      .permit(:description)
      .merge(reporter_id: current_user.id)
  end
end
