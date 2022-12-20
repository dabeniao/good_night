class User < ApplicationRecord
  validates :name, presence: true

  has_many :remember_tokens, dependent: :destroy
  has_many :active_relationships, class_name:  "Relationship",
                                  foreign_key: "follower_user_id",
                                  dependent:   :destroy
  has_many :passive_relationships, class_name:  "Relationship",
                                  foreign_key: "following_user_id",
                                  dependent:   :destroy
  has_many :following_users, through: :active_relationships, source: :following_user
  has_many :follower_users, through: :passive_relationships, source: :follower_user

  attr_accessor :remember_token_value

  def follow(target_user)
    relationship = active_relationships.find_or_initialize_by(following_user: target_user)
    relationship.save
  end

  def unfollow(target_user)
    relationship = active_relationships.find_by(following_user: target_user)
    return true if relationship.nil?

    relationship.destroy 
    relationship.destroyed?
  end

  def remember
    remember_token = self.remember_tokens.create
    return nil unless remember_token.persisted? 

    self.remember_token_value = remember_token.token
  end

  def forget(token_value=nil)
    token_value ||= self.remember_token_value
    return if token_value.nil?

    self.remember_tokens.where(token: token_value).destroy_all
  end
end
