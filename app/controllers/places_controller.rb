require 'pry'
class PlacesController < ApplicationController
before_action :check_if_admin!, only: [:edit]

  def index
    #binding.pry
    #if params.keys.include?("borough")
      @places = Place.all
  end

  def edit
    @place = Place.find(params[:id]) unless !Place.all.ids.include?(params[:id].to_i)
    if !@place.nil? && check_if_admin
      @place = Place.find(params[:id])
    else
      redirect_to places_path, alert: "Place not found."
      #add alert message
    end
  end


  def new
    if params[:itinerary_id] && !Itinerary.exists?(params[:itinerary_id])
    redirect_to itineraries_path, alert: "Itinerary not found."
    else
      @place = Place.new
      @current_user = current_user
      @itinerary = Itinerary.find(params[:itinerary_id])
      #@place.itineraries << @itinerary
    end
  end

  def create
    #binding.pry
    @itinerary = Itinerary.find(params[:itinerary_id])
    if params[:place][:id].empty? && (params[:place][:name].empty?||params[:place][:address].empty?) && correct_itin_user(@itinerary)
      #creating a new place with errors when address and name are not given and blank
      @itinerary = Itinerary.find(params[:itinerary_id])
      @place = Place.new(place_params)
      @place.save
      render :new
    elsif !params[:place][:id].empty? && (!params[:place][:name].empty?||!params[:place][:address].empty?)
      # asking user to pick only from selection or to add name and address -- add falsh message instead
      @itinerary = Itinerary.find(params[:itinerary_id])
      @place = Place.new
      @itinerary.errors.messages[:selection] = ["Choose existing place or create a new one with both fields"]
      render :new
    elsif !params[:place][:id].empty? && (params[:place][:name].empty? && params[:place][:address].empty?) && correct_itin_user(@itinerary)
      #creating a new place when only params[:place][:id] is given
      @place = Place.find(params[:place][:id])
      place_itin_association(params,@place)
      redirect_to itinerary_path(@itinerary)
    elsif !params[:place][:name].empty? && !params[:place][:address].empty? && correct_itin_user(@itinerary)
      #creating a new place when name and address are not blank
      @place = Place.find_by_name_address(params)
      if @place.nil?
        @place = Place.new(name: proper_case(params[:place][:name]), address: params[:place][:address])
        place_itin_association(params,@place)
        redirect_to itinerary_path(@itinerary)
      elsif !@place.nil?
        place_itin_association(params,@place)
        redirect_to itinerary_path(@itinerary)
      end

    end

  end

  def show
    @place = Place.find(params[:id])
  end

  def update
    #binding.pry
    #only admin can add address and edit name
    @place = Place.find(params[:id])
    if @place.valid? && check_if_admin
      @place.update(name: params[:place][:name]) unless params[:place][:name].empty?
      @place.update(address: params[:place][:address]) unless params[:place][:address].empty?
      redirect_to places_path
    elsif params.keys.include?("itinerary_id") && !check_if_admin
      @itinerary = Itinerary.find(params[:itinerary_id])
      if !params[:itinerary_id].empty? && !params[:id].empty? && @itinerary.user == current_user
        @itinerary = Itinerary.find(params[:itinerary_id])
        @place = Place.find(params[:id])
        @itinerary.places.delete(Place.find_by(id: params[:id]))
        @itinerary.save
        redirect_to itinerary_path(@itinerary)
      else
        redirect_to itineraries_path
      end
    else
      redirect_to places_path, alert: "Place not found."
    end
    #user removes place from own itinerary

  end

  private

  def place_params
    params.require(:place).permit(:name, :address)
  end

  def logged_in?
    !!session[:user_id]
  end

  def current_user
    User.find(session[:user_id])
  end

  def correct_itin_user(itinerary)
    @itinerary = itinerary
    current_user == @itinerary.user
  end

  def proper_case(string)
    string.split(/(\W)/).map(&:capitalize).join
  end

  def place_itin_association(params_hash,place)
    params = params_hash
    @place = place
    @itinerary = Itinerary.find(params[:itinerary_id])
    @place.itineraries << @itinerary unless @itinerary.places.include?(@place)
    @place.save
  end

  def check_if_admin
    current_user.username == 'admin'
  end

  def check_if_admin!
    unless check_if_admin
      redirect_to itineraries_path
    end
  end

end
