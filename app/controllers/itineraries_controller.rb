class ItinerariesController < ApplicationController

  def index
    @itineraries = Itinerary.all
  end

  def new
    @itinerary = Itinerary.new
    @user = User.find(session[:user_id])
  end

  def create
    #binding.pry
    @itinerary = Itinerary.new(itinerary_params, params[:user_id])
    if @itinerary.save
      @itinerary.user = User.find(session[:user_id])
      @itinerary.save
      #binding.pry
      redirect_to itineraries_path
    else
      @user = User.find(session[:user_id])
      render :new
    end
  end

  def show
    #binding.pry
    @itinerary = Itinerary.find(params[:id])
  end

  private

  def itinerary_params
    params.require(:itinerary).permit(:name, :description)
  end

  def logged_in?
    !!session[:user_id]
  end

end
