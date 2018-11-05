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
      @place = Place.new(place_params)
      @place.save
      render :new
    end

    if !params[:place][:id].empty?
      @place_e = Place.find(params[:place][:id])
      @itinerary = Itinerary.find(params[:itinerary_id])
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

  def show
    @place = Place.find(params[:id])
  end

  def update
    #binding.pry
    @itinerary = Itinerary.find(params[:itinerary_id])
    if !params[:itinerary_id].empty? && !params[:id].empty? && @itinerary.user == current_user
      @itinerary = Itinerary.find(params[:itinerary_id])
      @place = Place.find(params[:id])
      @itinerary.places.delete(Place.find_by(id: params[:id]))
      @itinerary.save
      redirect_to itinerary_path(@itinerary)
    end
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
