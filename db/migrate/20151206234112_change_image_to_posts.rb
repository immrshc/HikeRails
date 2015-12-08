class ChangeImageToPosts < ActiveRecord::Migration
  def up
  	change_column :Posts, :image, :binary
  end

  def down
  	change_column :Posts, :image, :string
  end
end
