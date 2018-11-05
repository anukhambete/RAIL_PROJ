require 'pry'
class SessionsController < ApplicationController
  def new
    @user = User.new
  end

  def create
    #binding.pry
    @user = User.find_by(username: params[:user][:username])
    #@user.authenticate(params[:user][:password])
    if @user.authenticate(params[:user][:password])
      session[:user_id] = @user.id
      redirect_to itineraries_path
    else
      @user.errors.messages[:password] = "does not match"
      #binding.pry
      render "sessions/new"
    end
  end

end
