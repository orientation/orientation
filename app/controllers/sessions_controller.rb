class SessionsController < ApplicationController
  def new
    session["return_to"] = request.env['HTTP_REFERER']
    redirect_to("/auth/google_oauth2", return_to: session["return_to"])
  end

  def create
    if user = User.find_or_create_from_omniauth(auth_hash)
      session[:user_id] = user.id
      flash[:notice] = "Signed in!"
    else
      flash[:error] = "You need a codescool.com or envylabs.com account to sign in."
    end
    # OmniAuth automaticall saves the HTTP_REFERER when you begin the auth process
    # Oh my dog, so nice, right?
    redirect_to( params[:return_to] || root_url )
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url, notice: "Signed out!"
  end

  protected

  def auth_hash
    request.env['omniauth.auth']
  end
end