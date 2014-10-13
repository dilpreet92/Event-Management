class ChangeContactNumberToString < ActiveRecord::Migration
  def change
    change_column :events, :contact_number, :string
  end
end
