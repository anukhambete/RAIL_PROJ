class ItinerariesController < ApplicationController
before_action :find_and_set_itinerary!, only: [:show, :edit, :update, :destroy]
before_action :logged_in?, only: [:new, :create, :show, :edit, :update, :destroy]
before_action :current_user, only: [:new, :create, :show, :edit, :update, :destroy]

  def index
    if logged_in?
      @itineraries = Itinerary.itin_ordered_list
      @current_user = current_user
    else
      redirect_to new_user_path
    end
  end

  def new
    if current_user.username == 'admin'
      redirect_to itineraries_path
    else
    @itinerary = Itinerary.new
    end

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
    if @itinerary.nil?
      redirect_to itineraries_path
    else
      #binding.pry
      if current_user_like_itins(current_user,@itinerary)
        #binding.pry
        @liked = Like.where(user_id: current_user.id,itinerary_id: @itinerary.id).first
        #binding.pry
      else
        @like = Like.new
      end
      #@like = Like.find_by(user_id: @current_user.id, itinerary_id: @itinerary.id)
    end
  end

  def edit
    @itinerary = Itinerary.find(params[:id])

    if @current_user != @itinerary.user
      @itineraries = Itinerary.all
      render :index
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

    if @itinerary.user == @current_user
      @itinerary.destroy
      redirect_to itineraries_path
    else
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
  end

  def itin_update_fail(params_hash)
    params = params_hash
    @user =  User.find(session[:user_id])
    @itinerary = Itinerary.find(params[:id])

    if @user == @itinerary.user
      if params[:itinerary][:name].empty? && params[:itinerary][:description].empty?
        @itinerary.errors.messages[:name] = ["Cannot leave name blank"]
        @itinerary.errors.messages[:description] = ["Cannot leave description blank"]
      elsif params[:itinerary][:name].empty?
        @itinerary.errors.messages[:name] = ["Cannot leave name blank"]
      elsif params[:itinerary][:description].empty?
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

  def current_user_like_itins(user, itinerary)
    arr =[]
    user.likes.each do |like|
      arr << like.itinerary_id
      arr
    end
    arr.include?(itinerary.id) ? true : false
  end

end
