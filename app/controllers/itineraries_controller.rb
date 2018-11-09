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
    @current_user = current_user
    @like = Like.find_by(user_id: @current_user.id, itinerary_id: @itinerary.id)
    #binding.pry
  end

  def edit
    @itinerary = Itinerary.find(params[:id])
    @user = User.find(session[:user_id])
  end

  def update
    #binding.pry
    @itinerary = Itinerary.find(params[:id])
    if current_user == @itinerary.user && @itinerary.update(itinerary_params)
      redirect_to itineraries_path
    else
      itin_update_fail(params)
      binding.pry
      render :edit
    end
  end

  def destroy
    #binding.pry
    @user = User.find(session[:user_id])
    @itinerary = Itinerary.find(params[:id])
    if @itinerary.user == @user
      @itinerary.destroy
      flash[:notice] = "Itinerary deleted."
      redirect_to itineraries_path
    else
      flash[:notice] = "Itinerary cannot be deleted."
      redirect_to itineraries_path
    end

  end

  private

  def itinerary_params
    params.require(:itinerary).permit(:name, :description)
  end

  def logged_in?
    !!session[:user_id]
  end

  def current_user
    User.find(session[:user_id])
  end

  def itin_update_fail(params_hash)
    params = params_hash
    @user =  User.find(session[:user_id])
    @itinerary = Itinerary.find(params[:id])

    if @user == @itinerary.user
      if params[:itinerary][:name].empty? && params[:itinerary][:description].empty?
        @user =  User.find(session[:user_id])
        @itinerary = Itinerary.find(params[:id])
        @itinerary.errors.messages[:name] = ["Cannot leave name blank"]
        @itinerary.errors.messages[:description] = ["Cannot leave description blank"]
      elsif params[:itinerary][:name].empty?
        @user =  User.find(session[:user_id])
        @itinerary = Itinerary.find(params[:id])
        @itinerary.errors.messages[:name] = ["Cannot leave name blank"]
      elsif params[:itinerary][:description].empty?
        @user =  User.find(session[:user_id])
        @itinerary = Itinerary.find(params[:id])
        @itinerary.errors.messages[:description] = ["Cannot leave description blank"]
      end
    end
  end

end
