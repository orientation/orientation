class SessionsController < ApplicationController
  def new
    origin = { origin: session.delete(:return_to) }.to_query
    redirect_to("/auth/google_oauth2?#{origin}")
  end

  def create
    user = User.find_or_create_from_omniauth(auth_hash)
    if user.valid?
      session[:user_id] = user.id
      flash[:notice] = "Signed in!"
      # OmniAuth automatically saves the HTTP_REFERER when you begin the auth process
      redirect_to  request.env['omniauth.origin'] || root_url
    else
      flash[:error] = "You need a #{ENV.fetch('ORIENTATION_DOMAIN')} account to sign in."
      redirect_to root_url
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url, notice: "Signed out!"
  end

  protected

  def auth_hash
    # calling to_h because Strong Parameters don't allow direct access
    # to request parameters, even when passed to a class outside the
    # controller scope.
    request.env['omniauth.auth'].to_h
  end
end
