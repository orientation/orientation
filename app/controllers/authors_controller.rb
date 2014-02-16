class AuthorsController < ApplicationController
  respond_to :html

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

  def new
    @author = User.new
  end

  def create
    @author = User.new(author_params)
    if @author.save
      flash[:notice] = "Yay, one of us!"
      redirect_to author_path(@author)
    else
      flash[:error] = "That didn't work out so well."
      render :new
    end
  end

  private

  def author_params
    params.require(:user).permit(:name, :email, :avatar)
  end

end
