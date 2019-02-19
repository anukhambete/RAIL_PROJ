require 'pry'
class PlacesController < ApplicationController
before_action :check_if_admin!, only: [:edit, :destroy]

  def index
    #binding.pry
    if params.keys.include?("borough")
      #binding.pry
      if params[:borough] == "All"
        @places = Place.all.ordlist
      else
        @places = Place.boro(params[:borough]).ordlist
      end
    else
      @places = Place.all.ordlist
    end

  end

  def edit
    @place = Place.find(params[:id]) unless !Place.all.ids.include?(params[:id].to_i)
    if !@place.nil? && check_if_admin
      @place = Place.find(params[:id])
      @current_user = current_user
    else
      redirect_to places_path
      #add alert message
    end
  end


  def new
    #if user is admin then allow path place_path(@place) after making place.new places/1

    if check_if_admin
      @place = Place.new
      @current_user = current_user
      #binding.pry
      #if regular user then params[:itinerary_id] must exist and the itinerary should exist
    elsif params[:itinerary_id] && !Itinerary.exists?(params[:itinerary_id])
      redirect_to itineraries_path, alert: "Itinerary not found."
      #msg alert saying access denied or itin not present
    elsif params[:itinerary_id].nil? && !check_if_admin
      redirect_to places_path
    else
      @place = Place.new
      @current_user = current_user
      @itinerary = Itinerary.find(params[:itinerary_id])
      #@place.itineraries << @itinerary
    end

  end

  def create
    ### admin can create a new place
    if current_user.username == 'admin'
      if params[:place][:name].empty? || params[:place][:address].empty?
        @place = Place.new(place_params)
        @place.save
        @current_user = current_user
        render :new
      elsif !params[:place][:name].empty? && !params[:place][:address].empty?
        @place = Place.find_or_create_by(name: proper_case(params[:place][:name]), address: params[:place][:address])
        redirect_to places_path
      end
    end
    #nonn-admin users can create places only under itineraries
    if current_user.username != 'admin'
      @itinerary = Itinerary.find(params[:itinerary_id])
      if correct_itin_user(@itinerary) #add if current user is correct
        @itinerary = Itinerary.find(params[:itinerary_id])
        method = user_create_number(params)
        if method == 1
          @place = Place.find(params[:place][:id])
          place_itin_association(params,@place)
          redirect_to itinerary_path(@itinerary)
        elsif method == 2
          @place = Place.where(name: proper_case(params[:place][:name]), address: params[:place][:address]).first_or_create
          place_itin_association(params,@place)
          redirect_to itinerary_path(@itinerary)
        else
          @itinerary = Itinerary.find(params[:itinerary_id])
          @place = Place.new
          @place.errors.messages[:selection] = ["Choose existing place or create a new one with both fields"]
          @current_user = current_user
          render :new
        end
      else
        redirect_to itineraries_path
      end
    end


  end

  def show
    @place = Place.find(params[:id]) unless !Place.all.ids.include?(params[:id].to_i)
    if !@place.nil?
      @place = Place.find(params[:id])
    else
      redirect_to places_path
      #add alert message
    end
  end

  def update
    ####only admin can add address and edit name
    @place = Place.find(params[:id])
    @place_existing = Place.find_by_name_address(params) unless !check_if_admin
    if @place.valid? && check_if_admin
      if @place_existing.empty?
        if !params[:place][:name].empty? && !params[:place][:address].empty?
          @place.update(name: proper_case(params[:place][:name])) unless params[:place][:name].empty?
          @place.update(address: params[:place][:address]) unless params[:place][:address].empty?
        end
        redirect_to places_path
      else
        @places = Place.all.order(:name, address: :asc)
        render :index
      end
    elsif params.keys.include?("itinerary_id") && !check_if_admin
      ####regular user updates itinerary to exclude place
      @itinerary = Itinerary.find(params[:itinerary_id])
      if !params[:itinerary_id].empty? && !params[:id].empty? && @itinerary.user == current_user
        # @itinerary = Itinerary.find(params[:itinerary_id])
        @place = Place.find(params[:id])
        @itinerary.places.delete(Place.find_by(id: params[:id]))
        @itinerary.save
        redirect_to itinerary_path(@itinerary)
      else
        redirect_to itineraries_path
      end
    else
      redirect_to places_path
    end
    #user removes place from own itinerary

  end

  def destroy
    @place = Place.find(params[:id])
    @place.destroy
    redirect_to places_path
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
    #binding.pry
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

  def user_create_number(params)
    params = params
    num = 0;
    if !params[:place][:id].empty? && (params[:place][:name].empty? && params[:place][:address].empty?)
      num = 1
    elsif params[:place][:id].empty? && (!params[:place][:name].empty? && !params[:place][:address].empty?)
      num = 2
    else
      num = 3
    end
    num
  end

end
