module ItinerariesHelper

def current_user_likes_itins(user, itinerary)
  arr =[]
  user.likes.each do |like|
    arr << like.itinerary_id
    arr
  end
  arr.include?(itinerary.id) ? true : false
end

def ratings_average(itinerary)
  @itinerary = itinerary

  arr =[]
  if !@itinerary.likes.empty?
    @itinerary.likes.each do |like|
      arr << like.rating
    end
    avg = arr.sum/arr.length
  else
    avg = ""
  end

end

end
