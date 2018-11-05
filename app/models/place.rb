class Place < ActiveRecord::Base
  has_many :itineraries
  has_many :users
  has_many :users through: :itineraries
end
