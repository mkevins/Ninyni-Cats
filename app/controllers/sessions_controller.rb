class SessionsController < ApplicationController

  before_action :redirect_current_user?, except: [:destroy]

  def new
    @user = User.new
    render :new
  end

  def create
    @user = User.find_by_credentials(*user_params.values)
    if @user
      login_user!
    else
      @user = User.new
      render :new
    end
  end

  def destroy
    flash[:message] = "Goodbye #{current_user.user_name}, :("
    current_user.reset_session_token!
    session[:session_token] = nil
    redirect_to cats_url
  end

  private

  def redirect_current_user?
    redirect_to cats_url if current_user
  end

  def user_params
    params.require(:user).permit(:user_name, :password)
  end

end
