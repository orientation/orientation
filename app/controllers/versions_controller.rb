class VersionsController < ApplicationController
  respond_to :html, :json

  def show
    @article = Article.find_by(slug: params[:article_id]).decorate

    @current_version = @article.versions.find_by(id: params[:id])
    @previous_version = @current_version.previous

    if @previous_version && @previous_version.object.present?
      @diff = Diffy::Diff.new(@previous_version.reify.content, @current_version.item.content).to_s
    elsif @previous_version && @previous_version.object.nil?
      original_content = YAML.load(@previous_version.object_changes)["content"].last

      @diff = Diffy::Diff.new(original_content, @current_version.item.content).to_s
    end

    respond_with @version
  end
end
