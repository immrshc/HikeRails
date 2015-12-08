class User < ActiveRecord::Base

	has_secure_password
	
	validates :username, presence: true
	
	def self.auth(username, password)
		user = find_by(username: username)
		if user && user.authenticate(password) then
			user
		else
			return
		end
	end

end
