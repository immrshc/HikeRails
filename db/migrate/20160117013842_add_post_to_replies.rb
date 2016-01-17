class AddPostToReplies < ActiveRecord::Migration
  def change
    add_reference :replies, :post, index: true, foreign_key: true
  end
end
