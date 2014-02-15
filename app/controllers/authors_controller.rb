class AuthorsController < ApplicationController
  def index
    authors = params[:all] ? User.all : User.author.prolific
    @authors = AuthorDecorator.decorate_collection authors
  end

  def show
    @author = AuthorDecorator.decorate User.find(params[:id])
  end

  def update
    @author = User.find(params[:id])
    @author.avatar = params[:author][:avatar]
    @author.save!

    flash[:notice] = "You look nice today."
    redirect_to author_path(@author)
  end
end
