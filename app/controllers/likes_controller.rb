require 'pry'
class LikesController < ApplicationController
  def create
    binding.pry
  end

  def update
  end

  private
  def current_user
    User.find(session[:user_id])
  end
end
