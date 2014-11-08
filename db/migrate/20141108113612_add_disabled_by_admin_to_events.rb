class AddDisabledByAdminToEvents < ActiveRecord::Migration
  def change
    add_column :events, :disabled_by_admin, :boolean, :default => false
  end
end
