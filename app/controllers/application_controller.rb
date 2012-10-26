class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  private

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
  helper_method :current_user

  def authenticate_user!
    if current_user
      true
    else
      flash[:notice] = "You need to #{view_context.link_to("log in", login_path, data: { no_turbolink: true } )} to do that.".html_safe
      redirect_to(:back)
    end
  end
  helper_method :current_user
end
