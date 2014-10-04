class CreateEventSessions < ActiveRecord::Migration
  def change
    create_table :event_sessions do |t|
      t.string :topic
      t.date :start_date
      t.date :end_date
      t.time :start_time
      t.time :end_time
      t.string :location
      t.string :speaker
      t.boolean :status
      t.integer :event_id

      t.timestamps
    end
  end
end
