class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :provider
      t.string :name
      t.string :access_token
      t.string :twitter_secret

      t.timestamps
    end
  end
end
