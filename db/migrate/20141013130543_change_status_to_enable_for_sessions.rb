class ChangeStatusToEnableForSessions < ActiveRecord::Migration
  def change
    rename_column :sessions, :status, :enable
  end
end
