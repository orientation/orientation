class VersionsController < ApplicationController
  respond_to :html, :json

  def show
    @version = Version.find(params[:id])
    respond_with @version
  end
end
