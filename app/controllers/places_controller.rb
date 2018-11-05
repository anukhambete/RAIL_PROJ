require 'pry'
class PlacesController < ApplicationController
  def new
    #binding.pry
    if params[:itinerary_id] && !Itinerary.exists?(params[:itinerary_id])
    redirect_to itineraries_path, alert: "Itinerary not found."
    else
      @place = Place.new
      @current_user = current_user
      @itinerary = Itinerary.find(params[:itinerary_id])
      @place.itineraries << @itinerary
    end
  end

  def create
    #binding.pry
    @place = Place.new(place_params)
    @itinerary = Itinerary.find(params[:itinerary_id])
    @place.itineraries << @itinerary 
    @place.save
    #binding.pry
    redirect_to itinerary_path(@itinerary)
  end

  private

  def place_params
    params.require(:place).permit(:name)
  end

  def logged_in?
    !!session[:user_id]
  end

  def current_user
    User.find(session[:user_id])
  end
end
