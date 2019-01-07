class ItinerariesController < ApplicationController
before_action :find_and_set_itinerary!, only: [:show, :edit, :update, :destroy]
before_action :logged_in?, only: [:new, :create, :show, :edit, :update, :destroy]
before_action :current_user, only: [:new, :create, :show, :edit, :update, :destroy]

  def index
    if logged_in?
      @itineraries = Itinerary.all
      @current_user = current_user
    else
      redirect_to new_user_path
    end
  end

  def new
    @itinerary = Itinerary.new
    #@user = User.find(session[:user_id])
  end

  def create
    #admin is not allowed to create new itineraries
    if @current_user.username != 'admin'
      @itinerary = Itinerary.new(itinerary_params, params[:user_id])
      if @itinerary.save
        @itinerary.user = User.find(session[:user_id])
        @itinerary.save
        redirect_to itinerary_path(@itinerary)
      else
        @current_user = User.find(session[:user_id])
        render :new
      end
    else
      redirect_to itineraries_path
    end
  end

  def show
    #find_and_set_itinerary!
    #@itinerary = Itinerary.find(params[:id]) unless !Itinerary.all.ids.include?(params[:id].to_i)
    if @itinerary.nil?
      redirect_to itineraries_path
      #add alert message
    else
      #@current_user = current_user
      @like = Like.find_by(user_id: @current_user.id, itinerary_id: @itinerary.id)
    end
  end

  def edit
    @itinerary = Itinerary.find(params[:id])
    #@user = User.find(session[:user_id])
    if @current_user != @itinerary.user
      @itineraries = Itinerary.all
      render :index #add warning saying that user does not have permission
    end
  end

  def update

    @itinerary = Itinerary.find(params[:id])
    if current_user == @itinerary.user && @itinerary.update(itinerary_params)
      redirect_to itinerary_path(@itinerary)
    else
      itin_update_fail(params)
      render :edit
    end
  end

  def destroy

    #@user = User.find(session[:user_id])
    #@itinerary = Itinerary.find(params[:id])
    if @itinerary.user == @current_user
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
    @current_user = User.find(session[:user_id])
    #@current_user = User.find(1)
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

  def find_and_set_itinerary!
    #binding.pry
    @itinerary = Itinerary.find(params[:id]) unless !Itinerary.all.ids.include?(params[:id].to_i)
    if @itinerary
      @itinerary
    else
      @itinerary = nil
    end
  end


end
