class ApplicationController < ActionController::Base
  helper_method :current_user
  
  def current_user
    User.find_by(session_token: session[:session_token])
  end

  def login!(user)
    session[:session_token] = user.reset_session_token!
  end

  def logout!
    session[:session_token] = nil
    user = current_user
    user.reset_session_token! if user
  end

end
