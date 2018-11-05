require 'pry'
class UsersController < ApplicationController

  def new
    @user = User.new
  end

  def create
    binding.pry
    @user = User.create(user_params)
    @user.save

    if @user.save
      @user.authenticate(params[:user][:password])
      session[:user_id] = @user.id
      #binding.pry
      redirect_to itineraries_path
    else
      redirect_to new_user_path
    end

  end

  def logout
    if logged_in?
      session.clear
      redirect_to "/"
    else
      redirect_to new_session_path
    end
  end

  private

  def user_params
    params.require(:user).permit(:username, :password, :email)
  end

  def logged_in?
    !!session[:user_id]
  end


end
