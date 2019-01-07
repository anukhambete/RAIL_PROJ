require 'pry'
class SessionsController < ApplicationController
  def new
    @user = User.new
  end

  def create
    #binding.pry
    @user = User.find_by(username: params[:user][:username])
    #@user.authenticate(params[:user][:password])
    if @user.nil?
      redirect_to new_user_path
    elsif @user.authenticate(params[:user][:password])
      session[:user_id] = @user.id
      redirect_to itineraries_path
    else
      @user.errors.messages[:password] = "does not match"
      #binding.pry
      render "sessions/new"
    end
  end

  def createfb
    #binding.pry
    @user = User.find_or_create_by(email: auth['info']['email']) do |u|
      u.username = auth['info']['name'] unless u.username != nil
      u.password = "facebooklogin" unless u.password != nil
    end
    #binding.pry
    if @user.save
      session[:user_id] = @user.id
      #binding.pry
      redirect_to itineraries_path
    else
      redirect_to new_user_path
    end

  end

  private
  def auth
    request.env['omniauth.auth']
  end

  def logged_in?
    !!session[:user_id]
  end

end
