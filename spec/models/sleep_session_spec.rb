require 'rails_helper'

RSpec.describe SleepSession, type: :model do
  let(:user) { create(:user) }
  let(:sleep_session) { build(:sleep_session, user: user) }

  describe 'sleep_session' do
    context 'with valid attributes' do
      it 'should be valid' do
        expect(sleep_session).to be_valid
      end
    end
    
    context 'with invalid sleep duration' do
      before do
        sleep_session.woke_at = sleep_session.slept_at - 1.minute
      end
      it 'should not be valid' do
        expect(sleep_session).to_not be_valid
      end
    end
  end
end
