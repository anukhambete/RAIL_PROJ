class User < ActiveRecord::Base
  has_secure_password
  has_many :itineraries
  has_many :places
  has_many :places through: :itineraries
end
