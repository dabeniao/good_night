FactoryBot.define do
  factory :relationship do
    follower_user_id { nil }
    following_user_id { nil }
  end
end
