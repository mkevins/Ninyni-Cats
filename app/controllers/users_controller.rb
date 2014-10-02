class UsersController < ApplicationController

  before_action :redirect_current_user?

  def new
    @user = User.new
    render :new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      login_user!
    else
      flash.now[:errors] = @user.errors.full_messages
      render :new
    end
  end

  private

  def redirect_current_user?
    redirect_to cats_url if current_user
  end

  def user_params
    params.require(:user).permit(:user_name, :password)
  end

end
