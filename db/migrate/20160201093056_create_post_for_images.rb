class CreatePostForImages < ActiveRecord::Migration
  def change
    create_table :post_for_images do |t|

      t.timestamps null: false
    end
  end
end
