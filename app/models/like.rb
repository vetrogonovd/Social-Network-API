class Like < ActiveRecord::Base
  validates_uniqueness_of :user_id, scope: :liked_id
  belongs_to :liked, polymorphic: true
end
