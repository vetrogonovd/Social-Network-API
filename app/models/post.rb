class Post < ActiveRecord::Base

  include S3Upload

  S3_BUCKET_NAME = 'investarena-post'

  validates :content,
            format: { with: /(?!&nbsp;.*)\A([\S])+([\s]*.+)*\z/, message: "The post content can't be blank" },
            length: { maximum: 63206 },
            allow_nil: true

  validates :access,
            format: { with: /\APrivate\z|\APublic\z/, message: "Invalid acecess" }

  validates :market,
            format: { with: /\ACurrency\z|\ACommodity\z|\AIndex\z|\AStock\z|\ACrypto\z|\ACryptoCurrency\z|\ASimple\z/, message: "Invalid market" }

  validates :quote,
            format: { with: /\A[A-Za-z]{1,20}\z/, message: "Invalid quote" },
            if: :with_forecast?

  validates :recommend,
            format: { with: /\ABuy\z|\ASell\z/, message: "Invalid recommend" },
            if: :with_forecast?

  validates :price,
            format: { with: /\A\d+\.?\d+\z/, message: "Invalid price" },
            length: { maximum: 50 },
            if: :with_forecast?

  validates :forecast,
            format: { with: /[\s0-9\-:.]/, message: "Invalid forecast" },
            length: { maximum: 30 },
            if: :with_forecast?

  belongs_to :user
  has_many :comments, as: :commentable, dependent: :destroy
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

  def return_likes_names(post, current_user)
    total_likes_count = like_count(post)
    if total_likes_count > 0
      likes_names = Set.new []
      if current_user
        if post.liked?(current_user.id, post.id)
          likes_names.merge([current_user.return_name])
        end
        followers_likes = Like.where("liked_id = ? AND user_id IN (?) AND user_id NOT IN (?)", post.id, current_user.followers.pluck(:id), current_user.id).limit(10 - likes_names.size)
        followers_likes_names = User.find( followers_likes.pluck(:user_id)).map{ |r| r.return_name }
        likes_names.merge(followers_likes_names)
        if likes_names.size < 10
          users_likes = Like.where("liked_id = ? AND user_id NOT IN (?)", post.id, current_user.id).limit(10 + likes_names.size)
          users_likes_names = User.find( users_likes.pluck(:user_id)).map{ |r| r.return_name }
          likes_names.merge(users_likes_names)
        end
      else
        users_likes = Like.where("liked_id = ?", post.id).limit(10 + likes_names.size)
        likes_names = User.find( users_likes.pluck(:user_id)).map{ |r| r.return_name }
      end
      if total_likes_count > 10
        result_names = likes_names.take(10)
        more_likes_count = total_likes_count - 10
        more_string = 'and '+ more_likes_count.to_s + ' more'
        result_names.push(more_string)
      else
        result_names = likes_names.take(total_likes_count)
      end
    else
      result_names = nil
    end
    result_names
  end

  private

  def with_forecast?
    market != 'Simple'
  end
end