class AddLogoAttachmentToEvents < ActiveRecord::Migration
  def change
    remove_column :events, :logo
    add_attachment :events, :logo
  end
end
