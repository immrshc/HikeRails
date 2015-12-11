class Timeline
	include ActiveModel::Model

	attr_accessor :post
	attr_accessor :favorite
	attr_accessor :favorite_count
	attr_accessor :imageURL

	def initialize(user_id, post)
		#postインスタンスを格納する
		self.post = post
		#show_imageメソッドを実行するためのURLを指定する
		if post.image then
			self.imageURL = "http://localhost:3000/post/show_image?post[id]=#{post.id}"
		else
			self.imageURL = ""
		end
		#自分がお気に入りをしているかBooleanで表現する
		self.favorite = Favorite.where(post: post, user_id: user_id).exists?
		#そのpostインスタンスが、何人のユーザにお気に入りされているか数字で表現する		
		self.favorite_count = Favorite.where(post: post).count
	end
end
