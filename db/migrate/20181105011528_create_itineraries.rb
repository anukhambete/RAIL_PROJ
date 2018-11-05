class CreateItineraries < ActiveRecord::Migration
  def change
    create_table :itineraries do |t|
      t.string :name
      t.string :description
      t.integer :user_id
    end
  end
end
