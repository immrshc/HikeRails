class AddImageHeightToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :image_height, :float
  end
end
