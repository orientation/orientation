class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  private

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
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
      logger.debug "authenticate_user! redirecting to root_path after saving the request URL"
      logger.debug "request.url is #{request.url}"
      session["return_to"] ||= request.url
      logger.debug "session['return_to'] is now #{session["return_to"]}"
      flash[:notice] = "You need to #{view_context.link_to("log in", login_path, data: { no_turbolink: true } )} to do that.".html_safe
      redirect_to root_path
    end
  end
  helper_method :current_user
end
