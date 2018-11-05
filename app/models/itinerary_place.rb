class ItineraryPlace < ActiveRecord::Base
  belongs_to :itinerary
  belongs_to :place
end
