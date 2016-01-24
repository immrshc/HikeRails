class Post < ActiveRecord::Base
  belongs_to :user
  validates :user, presence: true
  
  def data=(data)
  	self.ctype = data.content_type
  	self.image = data.read
  end

  def self.uploadToS3(image, post_id)

    if file_invalid?(image) then
      post = Post.find_by(id: post_id)
      username = post.user.username

      post.image_key = "#{username}/Post/#{image.original_filename}"
      post.ctype = image.content_type

      if post.save then
        Dotenv.load
        Aws.config.update(
          access_key_id: ENV["AWS_ACCESS_KEY_ID"],
          secret_access_key: ENV["AWS_SECRET_ACCESS_KEY"],
          region: ENV['REGION']
        )

        s3 = Aws::S3::Client.new(access_key_id: ENV["AWS_ACCESS_KEY_ID"], secret_access_key: ENV["AWS_SECRET_ACCESS_KEY"])
        res = s3.put_object(
          bucket: "www.imagehike", #バケット名
          body: image, #Fileオブジェクトかそれをreadしたバイナリを設定する 
          key: post.image_key, #バケット以下のパスを含むファイル名  
        )

        if res.etag then
          logger.debug("画像のアップロードが成功しました")
          return true
        else
          error.add("画像のアップロードが出来ませんでした") 
          return false
        end

      else
        error.add("コンテントタイプの保存に失敗しました")
        return false
      end
    else 
      error.add("画像の検証に失敗しました")
      return false
    end

  end

  def self.file_invalid?(image)
  	ps = ['image/jpeg', 'image/jpg', 'image/gif', 'image/png']
    if ps.include?(image.content_type) then
      if image.size < 1.megabyte then
        logger.debug("==========================================")
        logger.debug("#{image.size}の容量")
        logger.debug("#{image.content_type}は画像")
        return true
      else
        error.add("1MBのサイズを超えた#{image.size}の容量です")
        return false
      end
    else
      error.add("#{image.content_type}は画像ではありません")
      return false
    end
  end

  def self.downloadFromS3(post_id)

    post = Post.find_by(id: post_id)
    
    Dotenv.load
    Aws.config.update(
      access_key_id: ENV["AWS_ACCESS_KEY_ID"],
      secret_access_key: ENV["AWS_SECRET_ACCESS_KEY"],
      region: ENV['REGION']
    )

    s3 = Aws::S3::Client.new(access_key_id: ENV["AWS_ACCESS_KEY_ID"], secret_access_key: ENV["AWS_SECRET_ACCESS_KEY"])
    s3.get_object(
      bucket: "www.imagehike", #バケット名
      key: post.image_key, #バケット以下のパスを含むファイル名  
    )

  end

end
