class CreateReplies < ActiveRecord::Migration
  def change
    create_table :replies do |t|
      #t.references :post, index: true, foreign_key: true
      t.text :text

      t.timestamps null: false
    end
  end
end
