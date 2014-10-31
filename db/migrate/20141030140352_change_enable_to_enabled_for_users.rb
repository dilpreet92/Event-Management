class ChangeEnableToEnabledForUsers < ActiveRecord::Migration
  def change
    rename_column :users, :enable, :enabled
  end
end
