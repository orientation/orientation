module SessionsHelper
  def omniauth_path(type)
    "/auth/#{type}"
  end
end
