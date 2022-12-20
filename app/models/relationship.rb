class Relationship < ApplicationRecord
  belongs_to :follower_user, class_name: "User"
  belongs_to :following_user, class_name: "User"

  validates :follower_user_id, presence: true, uniqueness: { scope: :follower_user_id }
  validates :following_user_id, presence: true

  validate :check_self_following

  def check_self_following
    errors.add(:id, "self following is not allowed") if follower_user_id == following_user_id
  end
end
