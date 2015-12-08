class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.references :user, index: true, foreign_key: true
      t.text :text
      t.float :latitude
      t.float :longitude
      t.binary :image

      t.timestamps null: false
    end
  end
end
