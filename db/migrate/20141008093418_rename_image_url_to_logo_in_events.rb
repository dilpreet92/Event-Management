class RenameImageUrlToLogoInEvents < ActiveRecord::Migration
  def change
    rename_column :events, :image_url, :logo
  end
end
