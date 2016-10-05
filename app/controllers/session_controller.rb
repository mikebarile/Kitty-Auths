class SessionController < ApplicationController
  before_action :require_login, only: [:new, :create]

  def require_login
    redirect_to cats_url if current_user
  end

  def new
  end

  def create
    login_user!(session_params[:username], session_params[:password])
  end

  def destroy
    current_user.reset_session_token! if current_user
    session[:session_token] = nil
    redirect_to cats_url
  end

  private
  def session_params
    params.require(:user).permit(:username, :password)
  end

end
