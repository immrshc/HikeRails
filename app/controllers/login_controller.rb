class LoginController < ApplicationController

	def auth
		#{"password"=>"[FILTERED]", "username"=>"ShoichiImamura"}
		user = User.auth(params[:username], params[:password])

		if user then
			#login/auth.json.jbulderでユーザID, ユーザ名, それらの取得結果をJSON化する
			@user = user
			@result = true
		else
			@result = false
		end
	end

end
