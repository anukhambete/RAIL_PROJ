class AddItinPlaces < ActiveRecord::Migration
  def change
    create_table :itineraries_places do |t|
      t.integer :itinerary_id
      t.integer :place_id      
    end
  end
end
