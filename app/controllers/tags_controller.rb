class TagsController < ApplicationController
  before_action :find_tag_by_params, only: [
    :show,
    :edit,
    :update,
    :destroy
  ]
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
    @tag = Tag.new(tag_params)
    if @tag.save
      flash[:notice] = "Tag was successfully created."
    else
      flash[:error] = error_message(@tag)
    end
    respond_with @tag
  end

  def destroy
    redirect_to tags_url if @tag.destroy
  end

  def update
    if @tag.update_attributes(tag_params)
      flash[:notice] = "Tag was successfully updated."
    else
      flash[:error] = error_message(@tag)
    end
    respond_with @tag
  end

  private

  def error_message(tag)
    if tag.errors.messages.key?(:friendly_id)
      "#{tag.name} is a reserved word."
    elsif tag.errors.messages.key?(:name)
      "#{tag.name.presence || :name.to_s.titleize} #{tag.errors.messages[:name].first}."
    else
      "Tag could not be #{params[:action]}d."
    end
  end

  def find_tag_by_params
    @tag = Tag.friendly.find(params[:id])
  end

  def tag_params
    params.require(:tag).permit(:name)
  end
end
