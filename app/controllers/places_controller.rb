require 'pry'
class PlacesController < ApplicationController
  def new
    binding.pry
    if params[:itinerary_id] && !Itinerary.exists?(params[:itinerary_id])
    redirect_to itineraries_path, alert: "Itinerary not found."
    else
      @place = Place.new(itinerary_id: params[:itinerary_id])
      @current_user = current_user
      @itinerary = Itinerary.find(params[:itinerary_id])
    end
  end

  def create

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
