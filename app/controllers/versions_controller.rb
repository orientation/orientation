class VersionsController < ApplicationController
  respond_to :html, :json

  def show
    @article = Article.find_by(slug: params[:article_id]).decorate

    @current_version = @article.versions.where(id: params[:id]).first
    @previous_version = @current_version.previous

    if @previous_version
      @diff = Diffy::Diff.new(@previous_version.reify.content, @current_version.reify.content).to_s
    else
      @diff = @current_version.reify.content
    end

    respond_with @version
  end
end
