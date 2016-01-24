class RenameImagePathColumToImageKey < ActiveRecord::Migration
  def change
  	rename_column :posts, :image_path, :image_key
  end
end
