require 'rails_helper'

RSpec.describe "SleepSessions", type: :request do
  let(:user) { create(:user) }
  let(:another_user) { create(:user) }
  let(:yet_another_user) { create(:user) }
  let(:logged_in_headers) { 
    headers = {
      'X-AUTH-Token': user.remember
    }
    headers
  }

  describe "POST /sleep_sessions" do
    context 'with logged in user' do
      context 'with valid parameters' do
        before do
          @params = {
            sleep_session: {
              slept_at: 8.hours.ago,
              woke_at: 1.hours.ago
            }
          }
        end
        it 'should return 201' do
          post sleep_sessions_path, params: @params, headers: logged_in_headers
          expect(response).to have_http_status(:created)
        end
        it 'should respond with created sleep_session' do
          post sleep_sessions_path, params: @params, headers: logged_in_headers
          parsed_response = JSON.parse(response.body)
          expect(parsed_response).to include('id')
          expect(parsed_response).to include('slept_at')
          expect(parsed_response).to include('woke_at')
        end
        it 'should create a new sleep session for the user' do
          expect{
            post sleep_sessions_path, params: @params, headers: logged_in_headers
          }.to change{
            user.sleep_sessions.count
          }.by(1)
        end
      end
      context 'with invalid sleep duration in parameters' do
        before do
          @params = {
            sleep_session: {
              slept_at: 8.hours.ago,
              woke_at: 9.hours.ago
            }
          }
        end
        it 'should return 422' do
          post sleep_sessions_path, params: @params, headers: logged_in_headers
          expect(response).to have_http_status(:unprocessable_entity)
        end
        it 'should respond error messages' do
          post sleep_sessions_path, params: @params, headers: logged_in_headers
          parsed_response = JSON.parse(response.body)
          expect(parsed_response).to include('woke_at')
        end
        it 'should not create a new sleep session' do
          expect{
            post sleep_sessions_path, params: @params, headers: logged_in_headers
          }.to_not change{
            SleepSession.count
          }
        end
      end
      context 'with missing parameters' do
        it 'should raise ParamterMissing error' do
          expect{ 
            post sleep_sessions_path, params: {}, headers: logged_in_headers
          }.to raise_error ActionController::ParameterMissing
        end
      end
    end
    context 'with not logged in user' do
      it 'should return 401' do
        post sleep_sessions_path, params: {}
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe "GET /sleep_sessions" do
    before do
      user.sleep_sessions.create(slept_at: 3.day.ago - 2.hour, woke_at: 3.day.ago - 1.hour)
      @sleep_session_2 = user.sleep_sessions.create(slept_at: 2.day.ago - 2.hour, woke_at: 2.day.ago - 1.hour)
      user.sleep_sessions.create(slept_at: 1.day.ago - 2.hour, woke_at: 1.day.ago - 1.hour)

      @sleep_session_2.update(created_at: Time.now, updated_at: Time.now)

      @another_user_sleep_session = another_user.sleep_sessions.create(slept_at: 2.day.ago - 2.hour, woke_at: 2.day.ago - 1.hour)
    end
    context 'with logged in user' do
      before do
        get sleep_sessions_path, headers: logged_in_headers
        @parsed_response = JSON.parse(response.body)
      end
      it 'should return 200' do
        expect(response).to have_http_status(:ok)
      end
      it 'should respond with sleep_sessions' do
        expect(@parsed_response.first).to include('id')
        expect(@parsed_response.first).to include('slept_at')
        expect(@parsed_response.first).to include('woke_at')
        expect(@parsed_response.first).to include('created_at')
      end
      it 'should respond with 3 sleep_sessions' do
        expect(@parsed_response.length).to eq(3)
      end
      it 'should not respond with other users\'s sleep_sessions' do
        expect(@parsed_response.map{|ss| ss['id']}).to_not include(@another_user_sleep_session.id)
      end
      it 'should respond with sleep_sessions order by created_at in ascending order' do
        expect(@parsed_response.last['id']).to eq(@sleep_session_2.id)
      end
    end
    context 'with not logged in user' do
      it 'should return 401' do
        get sleep_sessions_path, params: {}
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe "GET /sleep_sessions/following" do
    before do
      another_user.sleep_sessions.create(slept_at: 3.day.ago - 8.hour, woke_at: 3.day.ago - 1.hour)
      @shortest_duration_sleep_session = another_user.sleep_sessions.create(slept_at: 2.day.ago - 6.hour, woke_at: 2.day.ago - 1.hour)
      another_user.sleep_sessions.create(slept_at: 1.day.ago - 7.hour, woke_at: 1.day.ago - 1.hour)

      @two_weeks_ago_sleep_session = another_user.sleep_sessions.create(slept_at: 14.day.ago - 7.hour, woke_at: 14.day.ago - 1.hour, created_at: 2.weeks.ago, updated_at: 2.weeks.ago)

      @my_sleep_session = user.sleep_sessions.create(slept_at: 2.day.ago - 2.hour, woke_at: 2.day.ago - 1.hour)
      @yet_another_user_sleep_session = yet_another_user.sleep_sessions.create(slept_at: 2.day.ago - 2.hour, woke_at: 2.day.ago - 1.hour)

      user.follow(another_user)
    end
    context 'with logged in user' do
      before do
        get following_sleep_sessions_path, headers: logged_in_headers
        @parsed_response = JSON.parse(response.body)
      end
      it 'should return 200' do
        expect(response).to have_http_status(:ok)
      end
      it 'should respond with sleep_sessions' do
        expect(@parsed_response.first['sleep_session']).to include('id')
        expect(@parsed_response.first['sleep_session']).to include('slept_at')
        expect(@parsed_response.first['sleep_session']).to include('woke_at')
        expect(@parsed_response.first['sleep_session']).to include('created_at')
      end
      it 'should respond with sleep_sessions\'s user info' do
        expect(@parsed_response.first['user']).to include('id')
        expect(@parsed_response.first['user']).to include('name')
      end
      it 'should respond with 3 sleep_sessions' do
        expect(@parsed_response.length).to eq(3)
      end
      it 'should respond with sleep_sessions order by sleep_duration in ascending order' do
        expect(@parsed_response.first['sleep_session']['id']).to eq(@shortest_duration_sleep_session.id)
      end
      it 'should not respond with sleep_sessions created two weeks ago' do
        expect(@parsed_response.map{|ss| ss['sleep_session']['id']}).to_not include(@two_weeks_ago_sleep_session.id)
      end
      it 'should not respond with not following users\'s sleep_sessions' do
        expect(@parsed_response.map{|ss| ss['sleep_session']['id']}).to_not include(@yet_another_user_sleep_session.id)
      end
      it 'should not respond with not self sleep_sessions' do
        expect(@parsed_response.map{|ss| ss['sleep_session']['id']}).to_not include(@my_sleep_session.id)
      end
    end
    context 'with not logged in user' do
      it 'should return 401' do
        get following_sleep_sessions_path
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
