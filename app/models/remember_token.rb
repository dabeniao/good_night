class RememberToken < ApplicationRecord
  belongs_to :user

  has_secure_token :token

  def self.valid
    all
  end
end
