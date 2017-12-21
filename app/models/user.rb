class User < ActiveRecord::Base

  devise :database_authenticatable, :registerable, :recoverable,
         :rememberable, :trackable, :validatable, :confirmable, :omniauthable
  include DeviseTokenAuth::Concerns::User

  NAME_LENGTH_MAXIMUM = 200
  NAME_LENGTH_MINIMUM = 1
  NAME_REGEX_VALIDATE = /\A([^~!@#'`"\\\/.()?,|*&%_+$;:\[\]{}><=\^\s\-]([^~!@#`"\\\/.()?,|*&%_+$;:\[\]{}><=\^]*[^~!@#'`"\\\/.()?,|*&%_+$;:\[\]{}><=\^\s\-])?){1,200}\z/
  NAME_MESSAGE = "You can use maximum length - #{NAME_LENGTH_MAXIMUM}, letters, numbers, space and symbols '-'"

  NICKNAME_LENGTH_MAXIMUM = 200
  NICKNAME_REGEX_VALIDATE = /\A([\S](.*[\S])?)?\z/
  NICKNAME_MESSAGE = "You can use maximum length - #{NAME_LENGTH_MAXIMUM}"

  EMAIL_LENGTH_MAXIMUM = 300
  EMAIL_REGEX_VALIDATE = /\A((([a-zA-Z0-9#!$%&'*+\-\/=?^_`{}|~]+(\.[a-zA-Z0-9#!$%&'*+\-\/=?^_`{}|~]+)*)|("[^"]*"))@([a-zA-Z0-9]+(_?-?[a-zA-Z0-9]+)*)(\.([a-zA-Z0-9]+(_?-?[a-zA-Z0-9]+)*)+)*(\.([a-zA-Z0-9]+(_?-?[a-zA-Z0-9]+)*){2,})){1,100}\z/

  validates :first_name, :last_name,
            format: { with: NAME_REGEX_VALIDATE, message: NAME_MESSAGE },
            length: { maximum: NAME_LENGTH_MAXIMUM, minimum: NAME_LENGTH_MINIMUM },
            allow_nil: true

  validates :nickname,
            format: { with: NICKNAME_REGEX_VALIDATE, message: NICKNAME_MESSAGE },
            length: { maximum: NICKNAME_LENGTH_MAXIMUM },
            allow_nil: true

  validates :email,
            format: { with: EMAIL_REGEX_VALIDATE },
            length: { maximum: EMAIL_LENGTH_MAXIMUM },
            allow_nil: true

  validates_presence_of :email, if: :email_required?

  has_one :settings, class_name: 'UserSettings', dependent: :destroy
  has_many :posts, dependent: :destroy
  has_many :comments, through: :commentable, dependent: :destroy
  has_many :likes, through: :posts, dependent: :destroy
  has_many :follower_relationships, foreign_key: :following_id, class_name: 'Follow'
  has_many :followers, through: :follower_relationships, source: :follower
  has_many :following_relationships, foreign_key: :follower_id, class_name: 'Follow'
  has_many :following, through: :following_relationships, source: :following
  has_many :group_users, dependent: :destroy
  has_many :groups, through: :group_users
  has_many :favorites, dependent: :destroy

  after_create :create_user_settings

  def create_user_settings
    self.create_settings
  end

  def follow(user_id)
    following_relationships.create(following_id: user_id)
  end

  def unfollow(user_id)
    following_relationships.find_by(following_id: user_id).destroy
  end

  def return_name
    @name = self.first_name + ' ' + self.last_name
  end

end
