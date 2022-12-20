class ApplicationController < ActionController::API
  include UserSessionsHelper

  before_action :logged_in_user
end
