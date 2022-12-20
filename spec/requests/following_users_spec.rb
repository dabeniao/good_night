require 'rails_helper'

RSpec.describe "FollowingUsers", type: :request do
  let(:user) { create(:user) }
  let(:another_user) { create(:user) }

  let(:logged_in_headers) { 
    headers = {
      'X-AUTH-Token': user.remember
    }
    headers
  }

  describe "PUT /{id}" do
    context 'with logged in user' do
      context 'with not already followed' do
        it 'should respond status code 200' do
          put following_user_path(another_user.id), headers: logged_in_headers
          expect(response).to have_http_status(:ok)
        end
        it 'should follow the target user' do
          expect{
            put following_user_path(another_user.id), headers: logged_in_headers
          }.to change{
            user.following_users.include?(another_user)
          }.from(false).to(true)
        end
      end
      context 'with already followed' do
        before do
          user.follow(another_user)
        end
        it 'should respond status code 200' do
          put following_user_path(another_user.id), headers: logged_in_headers
          expect(response).to have_http_status(:ok)
        end
        it 'should still follow the target user' do
          expect{
            put following_user_path(another_user.id), headers: logged_in_headers
          }.to_not change{
            user.following_users.include?(another_user)
          }
          expect( user.following_users.include?(another_user) ).to eq(true)
        end
      end
    end
    context 'with not logged in user' do
      it 'should respond with status code 401' do
        put following_user_path(another_user.id)
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
  describe "DELETE /{id}" do
    context 'with logged in user' do
      context 'with already unfollowed' do
        it 'should respond status code 200' do
          delete following_user_path(another_user.id), headers: logged_in_headers
          expect(response).to have_http_status(:ok)
        end
        it 'should still be not following the target user' do
          expect{
            delete following_user_path(another_user.id), headers: logged_in_headers
          }.to_not change{
            user.following_users.include?(another_user)
          }
          expect( user.following_users.include?(another_user) ).to eq(false)
        end
      end
      context 'with following another user' do
        before do
          user.follow(another_user)
        end
        it 'should respond status code 200' do
          delete following_user_path(another_user.id), headers: logged_in_headers
          expect(response).to have_http_status(:ok)
        end
        it 'should unfollow the target user' do
          expect{
            delete following_user_path(another_user.id), headers: logged_in_headers
          }.to change{
            user.following_users.include?(another_user)
          }.from(true).to(false)
        end
      end
    end
    context 'with not logged in user' do
      it 'should respond with status code 401' do
        delete following_user_path(another_user.id)
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
