class User < ActiveRecord::Base

	has_secure_password
	
	validates :username, presence: true

	def before_create
    	token = Digest::SHA1.hexdigest("#{id}#{rand.to_s}")[0..15]
    	write_attribute 'token', token
  	end
	
	def self.auth(username, password)
		user = find_by(username: username)
		if user && user.authenticate(password) then
			user
		else
			return
		end
	end


end
