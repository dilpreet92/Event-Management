class AddDescriptionToEventSessions < ActiveRecord::Migration
  def change
    add_column :event_sessions, :description, :text
  end
end
