class PostController < ApplicationController
	#nil_sessionだとsessionが破棄されるので、メソッド間の情報の引き渡しができない
	#AlamofireでStrongParametersができれば問題ない
	protect_from_forgery :except => [:upload_process]

	#アップロードされた投稿文の保存
	def create 
		user = User.find_by(token: user_params[:token], username: user_params[:username])
		post = Post.new(post_params)
		post.user = user
		if post.save then
			session[:post_id] = post.id
			@post = post
			@result = true
		else
			@result = false
		end
	end

	#上記のメソッドと分離する意味があるのか再考する
	#Xcode側での実行に依存するので改善する
	#アップロードされた画像のS3への保存	
	def upload_process
		if post_id = session[:post_id] then
			post = Post.find_by(id: post_id)
			image = params[:image]
			if PostForImage.uploadToS3(image, post) then
				@post = post
				@result = true
			else
				@result = false
			end
		else
			@result = false
		end
		session[:post] = nil
	end

	#S3からの画像のダウンロード
	def show_image
		post = Post.find_by(id: post_params[:id])
		ctype = post.ctype
		res = PostForImage.downloadFromS3(post)
		#ファイル名で取得しているので、名前が重複するとmetadata["content_type"]がnilになることがある
		send_data res.body.read, type: ctype, disposition: :inline
	end

	private 
	def post_params
		params.require(:post).permit(:id, :text, :latitude, :longitude)
		#{:text => "画像のアップロードテスト", :latitude => 37.33233141, :longitude => -122.0312186}
	end

	def user_params
		params.require(:user).permit(:token, :username)
	end

end
