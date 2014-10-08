class RenameSessionIdInUserSessionAssociations < ActiveRecord::Migration
  def change
    rename_column :user_session_associations, :session_id, :event_session_id
  end
end
