require 'rails_helper'

RSpec.describe User, type: :model do
  let!(:user) { build(:user) }

  describe 'user object' do
    context 'with valid attributes' do
      it 'should be valid' do
        expect(user).to be_valid
      end
    end
    context 'with missing name' do
      before do
        user.name = nil
      end
      it 'should not be valid' do
        expect(user).to_not be_valid
      end
    end
  end
end
