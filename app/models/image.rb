require 'fastimage'

class Image < ActiveRecord::Base

	attr_accessor :content_type
	attr_accessor :size
	attr_accessor :path
	attr_accessor :original_filename

	#after_actionはApplicationControllerを継承している時のみ使える
	def initialize(args)
		@content_type = args[:content_type]
		@size = args[:size]
		@path = args[:path]
		@original_filename = args[:original_filename]
	end

	#check uploadable
	def file_invalid?
    	ps = ['image/jpeg', 'image/jpg', 'image/gif', 'image/png']
    	unless ps.include?(@content_type) && @size < 1.megabyte then
        	raise "#{@content_type}は画像であり、1MBのサイズを超えないか、#{@size}の容量を確認してください"
	    end
    end

    #return image_key
	def get_image_key(username)
		"#{username}/Post/#{@original_filename}"
	end
	
    #return width
    def get_image_width()
    	get_image_frame[0]
    end

	#return height
    def get_image_height()
        get_image_frame[1]
    end

    #calculate frame of image
    def get_image_frame()
    	FastImage.size(@path)
    end
    private :get_image_frame

end
