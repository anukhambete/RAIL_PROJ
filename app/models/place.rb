class Place < ActiveRecord::Base
  has_many :itinerary_places
  has_many :itineraries, through: :itinerary_places
  has_many :users
  has_many :users, through: :itineraries
  validates :name, presence: true
end
