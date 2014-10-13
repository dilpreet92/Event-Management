class AddUniqueIndexToRsvps < ActiveRecord::Migration
  def change
    add_index :rsvps, [:user_id, :session_id], unique: true
  end
end
