class ChangeAddressToTextInEvents < ActiveRecord::Migration
  def change
    change_column :events, :address, :text
  end
end
