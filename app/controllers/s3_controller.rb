class S3Controller < ApplicationController

require 'dotenv'
require 'aws-sdk'

	def upload

		Dotenv.load
		Aws.config.update(
      		access_key_id: ENV["AWS_ACCESS_KEY_ID"],
      		secret_access_key: ENV["AWS_SECRET_ACCESS_KEY"],
      		region: ENV['REGION']
    	)

		s3 = Aws::S3::Client.new(access_key_id: ENV["AWS_ACCESS_KEY_ID"], secret_access_key: ENV["AWS_SECRET_ACCESS_KEY"])
		#array = []
		#resp = s3.list_objects(bucket: "www.imagehike")
		#resp.contents.each do |object|
    	#	array.push "#{object.key}"
		#end
		#render json: array
		file_open = File.open("/Users/Shoichi/desktop/HikeRails/app/controllers/Image03.jpg")
		file_name = File.basename("/Users/Shoichi/desktop/HikeRails/app/controllers/Image03.jpg")
		object = s3.put_object(
			bucket: "www.imagehike", #バケット名
			body: file_open, #Fileオブジェクトかそれをreadしたバイナリを設定する	
			key: "ShoichiImamura/Post/#{file_name}", #バケット以下のパスを含むファイル名	
			metadata: {
				"Content-Type" => "image/jpg"
			}
		)

		render json: object.etag
		
	end

	def download

		Dotenv.load
		Aws.config.update(
      		access_key_id: ENV["AWS_ACCESS_KEY_ID"],
      		secret_access_key: ENV["AWS_SECRET_ACCESS_KEY"],
      		region: ENV['REGION']
    	)

		s3 = Aws::S3::Client.new(access_key_id: ENV["AWS_ACCESS_KEY_ID"], secret_access_key: ENV["AWS_SECRET_ACCESS_KEY"])
		object = s3.get_object(
			bucket: "www.imagehike", #バケット名
			key: "ShoichiImamura/Post/Image03.jpg"#バケット以下のパスを含むファイル名	
		)
		
		#send_data object.body.read, type: object.metadata["content-type"], disposition: :inline
		render text: object.content_type#.metadata["content-type"]
	end

end
