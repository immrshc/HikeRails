class PostController < ApplicationController
	#nil_sessionだとsessionが破棄されるので、メソッド間の情報の引き渡しができない
	#AlamofireでStrongParametersができれば問題ない
	protect_from_forgery :except => [:upload_process]

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

	def upload_process

		if post_id = session[:post_id] then
			image = params[:image]

			post = Post.find_by(id: post_id)

			if Post.uploadToS3(image, post_id) then
				@post = post
				@result = true
				logger.debug("===================画像を投稿===================")
			else
				@result = false
				logger.debug("===================セッションがnil===================")
			end

		else
			@result = false
			logger.debug("===================セッションがnil===================")
		end

		session[:post] = nil
	end

	def show_image
		post_id = post_params[:id]
		ctype = Post.find_by(id: post_id).ctype
		res = Post.downloadFromS3(post_id)
		logger.debug("===================ctype===================")
		logger.debug(ctype)
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
