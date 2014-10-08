class RenameUserSessionAssociationsToRsvps < ActiveRecord::Migration
  def change
    rename_table :user_session_associations, :rsvps
  end
end
