class DeviseCreateAdmins < ActiveRecord::Migration
  def change
    create_table(:admins) do |t|

      t.string :username, null: false
      t.string :encrypted_password, null: false
      t.timestamps
    end
    add_index :admins, :username, unique: true
  end
end
