class User < ActiveRecord::Base
  has_secure_password
  has_many :itineraries
  has_many :likes
  has_many :liked_itineraries, through: :likes, source: :itinerary
  #has_many :places
  has_many :places, through: :itineraries

  validates :email, presence: true
  validates :username, presence: true
  #validates :password, presence: true

  validates_uniqueness_of :username
  validates_uniqueness_of :email
end
