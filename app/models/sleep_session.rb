class SleepSession < ApplicationRecord
  belongs_to :user

  validates :slept_at, presence: true
  validates :woke_at, presence: true

  validate :valid_sleep_duration

  def valid_sleep_duration
    errors.add(:woke_at, 'woke_at must be later than slept_at') if woke_at < slept_at
  end
end
