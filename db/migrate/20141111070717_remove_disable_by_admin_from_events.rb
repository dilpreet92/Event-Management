class RemoveDisableByAdminFromEvents < ActiveRecord::Migration
  def change
    remove_column :events, :disabled_by_admin
  end
end
