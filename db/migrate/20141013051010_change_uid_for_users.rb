class ChangeUidForUsers < ActiveRecord::Migration
  def change
    change_column :users, :uid, :string
  end
end