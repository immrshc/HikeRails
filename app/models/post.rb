class Post < ActiveRecord::Base
  belongs_to :user
  validate :file_invalid?, on: :update
  validates :user, presence: true
  
  def data=(data)
  	self.ctype = data.content_type
  	self.image = data.read
  end

  private
  def file_invalid?
  	ps = ['image/jpeg', 'image/jpg', 'image/gif', 'image/png']
    if ps.include?(self.ctype) then
      if self.image.length < 1.megabyte then
        logger.debug("==========================================")
        logger.debug("#{self.image.length}の容量")
        logger.debug("#{self.ctype}は画像")
      else
        error.add("1MBのサイズを超えた#{self.image.length}の容量です")
      end
    else
      error.add("#{self.image.ctype}は画像ではありません")
    end
  end

end
