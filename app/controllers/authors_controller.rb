class AuthorsController < ApplicationController
  def index
    @authors = User.author
  end

  def show
    @author = User.author.find(params[:id])
  end
end
