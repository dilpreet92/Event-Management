class AddProfilePictureToSpeakers < ActiveRecord::Migration
  def change
    add_attachment :speakers, :profile_picture
  end
end
