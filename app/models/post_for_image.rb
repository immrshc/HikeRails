class PostForImage < ActiveRecord::Base

  def self.uploadToS3(image, post)

    imageObj = Image.new(image_params(image))
    imageObj.file_invalid?

    post.image_key = imageObj.get_image_key(post.user.username)
    post.ctype = imageObj.content_type
    post.image_width = imageObj.get_image_width
    post.image_height = imageObj.get_image_height

    if post.save then
    	res = AccessorToAws.new.put_image(image, post.image_key)

        if res.etag then
          logger.debug("画像のアップロードが成功しました")
          return true
        else
          error.add("画像のアップロードが出来ませんでした") 
          return false
        end
    else
        error.add("Postインスタンスの保存に失敗しました")
        return false
    end

  end

  def self.downloadFromS3(post)
    AccessorToAws.new.get_image(post.image_key)
  end

  def self.image_params(image)
  	{content_type: image.content_type, size: image.size, path: image.path, original_filename: image.original_filename}
  end

end
