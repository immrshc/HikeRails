class RenameImageColumToImagepath < ActiveRecord::Migration
  def change
  	rename_column :posts, :image, :image_path
  end
end
