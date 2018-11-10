require 'pry'
class Place < ActiveRecord::Base
  has_many :itinerary_places
  has_many :itineraries, through: :itinerary_places
  has_many :users
  has_many :users, through: :itineraries
  validates :name, presence: true
  validates :address, presence: true
  scope :manhattan, -> { where(address: 'Manhattan') }
  scope :queens, -> { where(address: 'Queens') }
  scope :statenisland, -> { where(address: 'Staten Island') }
  scope :bronx, -> { where(address: 'Bronx') }
  scope :brooklyn, -> { where(address: 'Brooklyn') }
  scope :everything, -> { where(address: 'All') }

  def self.find_by_name_address(params_hash)
    #find all instances with matching parameters
    params = params_hash
    name = params[:place][:name].split(/(\W)/).map(&:capitalize).join
    address = params[:place][:address]
    place = Place.where(name: name, address: address)
    if !place.nil?
      place
    else
      nil
    end
  end
end
