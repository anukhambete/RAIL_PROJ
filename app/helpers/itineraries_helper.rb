module ItinerariesHelper

def current_user_likes_itins(user, itinerary)
  arr =[]
  user.likes.each do |like|
    arr << like.itinerary_id
    arr
  end
  arr.include?(itinerary.id) ? true : false  
end



end
