require 'rails_helper'

RSpec.describe RememberToken, type: :model do
  let!(:user) { create(:user) }
  let!(:remember_token) { build(:remember_token, user: user) }

  describe 'remember_token model' do
    context 'with empty token' do
      it 'should generate a token on save' do
        expect{
          remember_token.save
        }.to change{
          remember_token.token.nil?
        }.from(true).to(false)
      end
    end
  end
end
