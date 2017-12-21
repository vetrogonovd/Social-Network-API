class Group < ActiveRecord::Base

  include S3Upload

  S3_BUCKET_NAME = 'investarena-group-image'

  validates :name,
            format: { with: /(?!&nbsp;.*)\A([\S])+([\s]*.+)*\z/ },
            length: { maximum: 200 },
            presence: true

  validates :description,
            format: { with: /\A\z|(?!&nbsp;.*)\A([\S])+([\s]*.+)*\z/, message: "can't be blank" },
            length: { maximum: 300 },
            allow_nil: true

  validates :access,
            format: { with: /\APrivate\z|\APublic\z/ }

  has_many :group_users, dependent: :destroy
  has_many :users, through: :group_users

  after_destroy :delete_image

  def add_users(users)
    users.each do |user|
      GroupUser.create(group_id: id, user_id: user, role: 2) if User.exists? user
    end
  end

  def set_owner
    GroupUser.find_by(group_id: self).update(role: 'owner')
  end

  def change_user_role(user, role)
    GroupUser.find_by(group_id: self, user_id: user).update(role: role)
  end

  def update_image(new_image)
    if image.blank? && new_image.present?
      update(image: upload_file(new_image, S3_BUCKET_NAME))
    elsif image.present? && new_image.blank?
      delete_file(image, S3_BUCKET_NAME)
      update(image: '')
    elsif image.present? && new_image.present?
      update(image: update_file(new_image, image, S3_BUCKET_NAME))
    end
  end

  def delete_image
    delete_file(image, S3_BUCKET_NAME) if image.present?
  end
end