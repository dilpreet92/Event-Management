class CreateUserSessionAssociations < ActiveRecord::Migration
  def change
    create_table :user_session_associations do |t|
      t.integer :user_id
      t.integer :session_id
      t.integer :event_id
      t.timestamps
    end
  end
end
