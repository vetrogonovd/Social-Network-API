class Favorite < ActiveRecord::Base

  validates_uniqueness_of :quote, scope: :user_id
  validates :quote, length: { maximum: 25 }, presence: true

  belongs_to :user
end