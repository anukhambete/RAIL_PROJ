class AddRatingToLikes < ActiveRecord::Migration
  def change
    add_column :likes, :rating, :integer
  end
end
