class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :name
      t.date :start_date
      t.date :end_date
      t.time :start_time
      t.time :end_time
      t.string :address
      t.string :city
      t.string :country
      t.integer :contact_number
      t.text :description
      t.boolean :status, default: true
      t.string :image_url

      t.timestamps
    end
  end
end
