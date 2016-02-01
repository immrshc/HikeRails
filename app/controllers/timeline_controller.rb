class TimelineController < ApplicationController

	def show_timeline

		timeLineArray = []
		user_token = user_params[:token]
		user = User.find_by_token(user_token)
		if user then
			user_id = user.id
			posts = Post.all
			#postインスタンスを投稿用のインスタンスに変えて、配列にする
			posts.each do |post|
				timeLineArray.push Timeline.new(user_id, post)
			end

			#render json: timeLineArray[0].post.user.username
			#なぜか他のjbuilderではできるが、ここのjson.username timeLine.post.user.usernameはできない
			@timeLineArray = timeLineArray.reverse
		else
			@timeLineArray = nil
		end
		
	end

	def show_mypost

		timeLineArray = []
		user_token = user_params[:token]
		user = User.find_by_token(user_token)
		if user then
			user_id = user.id
			#自分の投稿したPostインスタンスの配列
			#Post.user.idにuser_idでアクセスできる		
			posts = Post.where(user_id: user_id)
			posts.each do |post|
				timeLineArray.push Timeline.new(user_id, post)
			end

			@timeLineArray = timeLineArray.reverse
		else
			@timeLineArray = nil
		end

	end

	def show_myfavorite

		timeLineArray = []
		user_token = user_params[:token]
		user = User.find_by_token(user_token)
		if user then
			user_id = user.id
			favorites = Favorite.where(user_id: user_id)
			favorites.each do |favorite|
				post_id = favorite.post.id
				post = Post.find_by(id: post_id)
				timeLineArray.push Timeline.new(user_id, post)
			end
			#自分のお気に入りをしたPostインスタンスの配列		
			@timeLineArray = timeLineArray.reverse
		else
			@timeLineArray = nil
		end
	end

	private 
	def user_params
		params.require(:user).permit(:token, :username, :mail, :password)
	end

end
