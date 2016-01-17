class ChangeImageToPosts < ActiveRecord::Migration
  def up
  	change_column :posts, :image, :binary
  end

  def down
  	change_column :posts, :image, :string
  end
end
