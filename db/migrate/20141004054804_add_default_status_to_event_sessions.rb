class AddDefaultStatusToEventSessions < ActiveRecord::Migration
  def change
    change_column_default :event_sessions, :status, true
  end
end
