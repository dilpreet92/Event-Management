class ChangeColumnStatusToEnableInRsvps < ActiveRecord::Migration
  def change
    rename_column :events, :status, :enable
    remove_column :rsvps, :event_id
  end
end
