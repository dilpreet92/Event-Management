class RemoveSpeakerFromSessions < ActiveRecord::Migration
  def change
    remove_column :sessions, :speaker, :string
  end
end
