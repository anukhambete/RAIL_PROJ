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
    @itinerary = Itinerary.find(params[:itinerary_id])
    if params[:place][:id].empty? && params[:place][:name].empty?
      @itinerary = Itinerary.find(params[:itinerary_id])
      @place = Place.new
      render :new
    end

    if !params[:place][:id].empty?
      @place_e = Place.find(params[:place][:id])
      @place_e.itineraries << @itinerary unless @itinerary.places.include?(@place_e)
      @place_e.save
      redirect_to itinerary_path(@itinerary)
    end

    if !params[:place][:name].empty?
      @place = Place.find_or_create_by(name: place_params[:name])
      @itinerary = Itinerary.find(params[:itinerary_id])
      @place.itineraries << @itinerary unless @itinerary.places.include?(@place)
      @place.save
      redirect_to itinerary_path(@itinerary)
    end
    #binding.pry
    #redirect_to itinerary_path(@itinerary)
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
