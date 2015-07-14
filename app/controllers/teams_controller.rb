class TeamsController < ApplicationController
  def index

  end

  def show
    @team = Team.friendly.find(params[:id])
  end
end
