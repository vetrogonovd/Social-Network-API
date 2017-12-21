class GroupUser < ActiveRecord::Base

  validates :role, presence: true

  belongs_to :user
  belongs_to :group

  enum role: [:owner, :admin, :user]
end