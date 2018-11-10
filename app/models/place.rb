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
    params = params_hash
    name = params[:place][:name].split(/(\W)/).map(&:capitalize).join
    address = params[:place][:address]
    place = self.find_by(name: name)
    if !place.nil? && place.address == params[:place][:address]
      place
    else
      nil
    end
  end
end
