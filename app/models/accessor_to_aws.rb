
class AccessorToAws

  attr_accessor :s3
  
  def initialize()
    @s3 = aws_accessor()
  end

  def get_image(image_key)
    @s3.get_object(
      bucket: "www.imagehike", #バケット名
      key: image_key, #バケット以下のパスを含むファイル名  
    )
  end

  def put_image(image, image_key)
    #引数の順番と代入される順番が異なるとエラーが生じる
    @s3.put_object(
      bucket: "www.imagehike", #バケット名
      body: image, #Fileオブジェクトかそれをreadしたバイナリを設定する 
      key: image_key, #バケット以下のパスを含むファイル名  
    )
  end

  def aws_accessor()
    Dotenv.load
    Aws.config.update(
      access_key_id: ENV["AWS_ACCESS_KEY_ID"],
      secret_access_key: ENV["AWS_SECRET_ACCESS_KEY"],
      region: ENV['REGION']
    )
    Aws::S3::Client.new(access_key_id: ENV["AWS_ACCESS_KEY_ID"], secret_access_key: ENV["AWS_SECRET_ACCESS_KEY"])
  end
  private :aws_accessor

end
