class AddItinPlaces < ActiveRecord::Migration
  def change
    create_table :itinerary_places do |t|
      t.integer :itinerary_id
      t.integer :place_id
    end
  end
end
