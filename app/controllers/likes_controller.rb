require 'pry'
class LikesController < ApplicationController
  def create
    #binding.pry
    @itinerary = Itinerary.find(params[:itinerary_id])
    @like = Like.find_or_create_by(itinerary_id: @itinerary.id, user_id: current_user.id, rating: params[:like][:rating].to_i)
    redirect_to itinerary_path(@itinerary)
    #binding.pry

  end


  def update
     @itinerary = Itinerary.find(params[:id])
     #binding.pry
    @like = Like.find_by(itinerary_id: @itinerary.id, user_id: current_user.id)
    @like.update(rating: params[:like][:rating])
    redirect_to itinerary_path(@itinerary)
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
