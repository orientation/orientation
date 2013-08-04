class AuthorsController < ApplicationController
  def index
    @authors = AuthorDecorator.decorate_collection User.author
  end

  def show
    @author = User.author.find(params[:id])
  end
end
