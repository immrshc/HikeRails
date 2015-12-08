class Post < ActiveRecord::Base
  belongs_to :user
  #validate :file_invalid? 
  validates :user, presence: true
  
  def data=(data)
  	self.ctype = data.content_type
  	self.image = data.read
  end

  #private
  def file_invalid?
  	ps = ['image/jpeg', 'image/jpg', 'image/gif', 'image/png']
  	errors.add(:image, 'は画像ではありません') if !ps.include?(self.ctype)
  	errors.add(:image, 'のサイズが1MBを超えています') if self.image.length > 1.megabyte
  end

end
