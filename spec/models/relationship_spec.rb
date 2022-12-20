require 'rails_helper'

RSpec.describe Relationship, type: :model do
  describe 'relationship model' do

    let(:user1) { create(:user) }
    let(:user2) { create(:user) }
    let(:relationship) { build(:relationship, follower_user: user1, following_user: user2) }

    context 'with valid relation' do
      it 'should be valid' do
        expect(relationship).to be_valid
      end
    end

    context 'with self following relation' do
      before do
        relationship.following_user = user1
      end
      it 'should not be valid' do
        expect(relationship).to_not be_valid
      end
    end

  end
end
