class ChangeImageTypeInPosts < ActiveRecord::Migration
  def up
  	change_column :posts, :image, :string
  end

  def down
  	change_column :posts, :image, :binary
  end
end
