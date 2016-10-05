class UsersController < ApplicationController
  before_action :require_login, only: [:new, :create]

  def require_login
    redirect_to cats_url if current_user
  end

  def show
  end

  def new
  end

  def create
    user = User.new(user_params)
    if user.save
      session[session_token] = user.session_token
      redirect_to user_url(user)
    else
      flash[:errors] = user.errors.full_messages
      redirect_to new_user_url
    end
  end

  private

  def user_params
    params.require(:user).permit(:username, :password)
  end
end
