class ChangeDatetimeInEventsAndSessions < ActiveRecord::Migration
  def change
    remove_column :events, :start_time
    remove_column :events, :end_time
    change_column :events, :start_date, :datetime
    change_column :events, :end_date, :datetime
    remove_column :event_sessions, :start_time
    remove_column :event_sessions, :end_time
    change_column :event_sessions, :start_date, :datetime
    change_column :event_sessions, :end_date, :datetime
  end
end
