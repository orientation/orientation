require "application_responder"

class ApplicationController < ActionController::Base
  self.responder = ApplicationResponder
  respond_to :html

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_filter :authenticate_user!

  def upload_image
    uploader = ImageUploader.new
    uploader.store!(params[:image])
    render json: { image: uploader.url, filename: uploader.file.filename}
  end

  private

  def current_user
    @current_user ||= begin
      user = nil

      # In the development environment, your current_user will be the
      # first User in the database or a dummy one created below.
      if !Rails.env.production?
        user = User.first_or_create(email: "alvar@hanso.dk", name: "Alvar Hanso")
        session[:user_id] = user.id
        flash[:notice] = "Signed in!"
      else
        user = User.find(session[:user_id]) if session[:user_id].present?
      end

      # Draper decorators still instantiate a decorator when passed nil,
      # so we have to be careful not to return anything if no user could
      # be found.
      AuthorDecorator.decorate(user) if user.present?
    end
  end
  helper_method :current_user

  def user_signed_in?
    current_user.present?
  end
  helper_method :user_signed_in?

  def authenticate_user!
    if current_user
      true
    else
      session["return_to"] ||= request.url
      redirect_to login_path unless login_redirect? or oauth_callback?
    end
  end
  helper_method :authenticate_user!

  def login_redirect?
    request.path == login_path
  end

  def oauth_callback?
    request.path == oauth_callback_path("google_oauth2")
  end
end
