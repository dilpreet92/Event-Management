class ChangeEventSessionToSessions < ActiveRecord::Migration
  def change
    rename_table :event_sessions, :sessions
    rename_column :rsvps, :event_session_id, :session_id
  end
end
