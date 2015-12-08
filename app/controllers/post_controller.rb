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

	#このメソッドの時のみ画像のvalidateが実行されるようにする
	def upload_process

		logger.debug("===================debug===================")
		logger.debug(session[:post_id])
		
		ps = ['image/jpeg', 'image/jpg', 'image/gif', 'image/png']

		if post_id = session[:post_id] then
			image = params[:image].read
			ctype = params[:image].content_type
			post = Post.find_by(id: post_id)

  			if ps.include?(ctype) && image.length < 1.megabyte then
				if post.update(image: image, ctype: ctype) then
					@post = post
					@result = true
					logger.debug("===================画像を保存===================")
				else
					@result = false
					logger.debug("===================画像を保存できない===================")
				end		
			else
				logger.debug('#{image.ctype}は画像ではありません') 
	  			logger.debug('#{image.length}のサイズが1MBを超えています')
				@result = false
			end
		else
			@result = false
			logger.debug("===================セッションがnil===================")
		end

		session[:post] = nil

	end

	def show_image

		post_id = post_params[:id]
		@post = Post.find_by(id: post_id)
		if @post.image && @post.ctype then
			send_data @post.image, type: @post.ctype, disposition: :inline
		else
			@post = Post.find_by(id: 31)
			send_data @post.image, type: @post.ctype, disposition: :inline
		end

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
