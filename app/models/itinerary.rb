class Itinerary < ActiveRecord::Base
  has_many :itinerary_places
  has_many :places, through: :itinerary_places
  has_many :likes
  has_many :liked_users, through: :likes, source: :user
  belongs_to :user
  accepts_nested_attributes_for :user

  validates :name, presence: true
  validates :description, presence: true
  #validates :password, presence: true

  validates_uniqueness_of :name

  def self.itin_ordered_list
    array = []
    Itinerary.all.each do |itin|
      array << {itin => itin.likes.count}
    end
    list = array.reduce Hash.new, :merge
    list = list.sort_by {|_key, value| value}.reverse
    temp = []
    list.each do |obj|
      temp << obj[0]
    end
    temp
  end





end
