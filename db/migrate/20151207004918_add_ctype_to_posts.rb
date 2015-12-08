class AddCtypeToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :ctype, :string
  end
end
