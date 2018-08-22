class Micropost < ApplicationRecord
  before_validation :direction_to_reply #バリデーションする前にリプライ先を確認する
  belongs_to :user
  default_scope -> { order(created_at: :desc) }
  mount_uploader :picture, PictureUploader
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }
  validate  :picture_size

  private

    # アップロードされた画像のサイズをバリデーションする
    def picture_size
      if picture.size > 5.megabytes
        errors.add(:picture, "should be less than 5MB")
      end
    end

    #「@」を探し、user_idだった場合はreply先を指定する
    def direction_to_reply
      if @index = content.index("@")
        id = []
        while !(content[@index+1] == "-")
          id << content[@index+1]
          @index +=1
        end
        if id.join.to_i == 0
        else
			    self.in_reply_to = id.join.to_i
	        reply_user = User.find(id.join.to_i)
	        UserMailer.reply_email(reply_user).deliver_now
	      end
      else
        self.in_reply_to = 0
      end
    end

end