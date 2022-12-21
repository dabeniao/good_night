FactoryBot.define do
  factory :sleep_session do
    user { nil }
    slept_at { 8.hours.ago }
    woke_at { 1.minute.ago }
  end
end
