class TagsController < ApplicationController
  respond_to :json, :html

  def index
    @ordered_tags = Tag.by_article_count
    @tags = Tag.order(:name)
    respond_with do |format|
      format.json { render json: @tags.tokens(params[:q]) }
    end
  end

  def new
    respond_with @tag = Tag.new
  end

  def create
    respond_with @tag = Tag.create(tag_params)
  end

  def show
    @tag = find_tag_by_params
  end

  def edit
    @tag = find_tag_by_params
  end

  private

  def find_tag_by_params
    Tag.friendly.find(params[:id])
  end

  def tag_params
    params.require(:tag).permit(:name)
  end
end
