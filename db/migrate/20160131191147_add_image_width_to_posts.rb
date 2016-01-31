class AddImageWidthToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :image_width, :float
  end
end
