class Comment < ActiveRecord::Base

  include S3Upload

  S3_BUCKET_NAME = 'investarena-comment'

  COMMENT_LENGTH_MAXIMUM = 8192
  CONTENT_REGEX_VALIDATE = /(?!&nbsp;.*)\A([\S])+([\s]*.+)*\z/

  validates :content,
            format: { with: CONTENT_REGEX_VALIDATE, message: "The comment can't be blank" },
            length: { maximum: COMMENT_LENGTH_MAXIMUM },
            allow_nil: true

  belongs_to :user
  belongs_to :commentable, polymorphic: true
  has_many :comments, as: :commentable
  has_many :likes, as: :liked, dependent: :destroy
  has_one :meta_tags, class_name: 'MetaTag', as: :object, dependent: :destroy

  def upload_image(new_file)
    update(file: upload_file(new_file, S3_BUCKET_NAME)) if new_file.present?
  end

  def update_image(new_file)
    if file.blank? && new_file.present?
      update(file: upload_file(new_file, S3_BUCKET_NAME))
    elsif file.present? && new_file.blank?
      delete_file(file, S3_BUCKET_NAME)
      update(file: nil)
    elsif file.present? && new_file.present?
      update(file: update_file(new_file, file, S3_BUCKET_NAME))
    end
  end

  def delete_image
    delete_file(file, S3_BUCKET_NAME) if file.present?
  end

  def liked?(user_id, liked_id)
    Like.find_by(user_id: user_id, liked_id: liked_id).present?
  end

  def like_count(liked_id)
    Like.where(liked_id: liked_id).count
  end
end
