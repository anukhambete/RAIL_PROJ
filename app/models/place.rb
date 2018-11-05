class Place < ActiveRecord::Base
  has_many :itineraries
  has_many :itineraries, through: :itineraries_places
  has_many :users
  has_many :users, through: :itineraries
end
