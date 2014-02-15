class AuthorsController < ApplicationController
  def index
    @authors = AuthorDecorator.decorate_collection User.author.prolific
  end

  def show
    @author = AuthorDecorator.decorate User.author.find(params[:id])
  end

  def update
    @author = User.find(params[:id])
    @author.avatar = params[:author][:avatar]
    @author.save!

    flash[:notice] = "You look nice today."
    redirect_to author_path(@author)
  end
end
