class AddIndexToLikesAttributes < ActiveRecord::Migration[6.0]
  def change
    add_index(:likes,[:user_id,:sighting_id], unique: true)
  end
end
