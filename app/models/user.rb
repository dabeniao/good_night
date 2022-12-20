class User < ApplicationRecord
  validates :name, presence: true

  has_many :remember_tokens, dependent: :destroy

  attr_accessor :remember_token_value

  def remember
    remember_token = self.remember_tokens.create
    return nil unless remember_token.persisted? 

    self.remember_token_value = remember_token.token
  end

  def forget(token_value=nil)
    token_value ||= self.remember_token_value
    self.remember_tokens.where(token: token_value).destroy_all
  end
end
