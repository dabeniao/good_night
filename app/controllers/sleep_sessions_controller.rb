class SleepSessionsController < ApplicationController

  def index
    render json: current_user.sleep_sessions.order(:created_at)
  end

  def create
    sleep_session = current_user.sleep_sessions.new(sleep_session_params)

    if sleep_session.save
      render json: sleep_session, status: 201
    else
      render json: sleep_session.errors, status: 422
    end
  end

  def following
    since_timestamp = 1.week.ago

    sleep_sessions = SleepSession
      .where(user: current_user.following_users)
      .where("created_at > ?", since_timestamp)
      .includes(:user)

    # Note
    # the `extract epoch` syntax is PostgreSQL only
    # use `timediff` instead for MySQL or MariaDB 
    sleep_sessions = sleep_sessions.order(Arel.sql("extract(epoch from woke_at - slept_at)"))

    @sleep_sessions = sleep_sessions
    # rendering is processed by jbuilder
  end

  private
  def sleep_session_params
    params.require(:sleep_session).permit(:slept_at, :woke_at)
  end

end
