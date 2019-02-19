require 'pry'
class LikesController < ApplicationController
  def create
    #binding.pry
    @itinerary = Itinerary.find(params[:itinerary_id])
    @like = Like.find_or_create_by(itinerary_id: @itinerary.id, user_id: current_user.id)
    redirect_to itinerary_path(@itinerary)
    #binding.pry

  end


  def destroy
    #binding.pry
    @like = Like.find_by(id: params[:id])
    @itinerary = Itinerary.find(@like.itinerary.id)
    @like.destroy
    redirect_to itinerary_path(@itinerary)
  end

  private
  def current_user
    User.find(session[:user_id])
  end

end
