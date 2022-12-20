module UserSessionsHelper

  def logged_in?
    current_user.nil? == false
  end

	def logged_in_user
		unless logged_in?
			render json:'', status: 401
		end
	end

	def current_user=(user)
		@current_user = user
	end

	def current_user
		unless @current_user
      remember_token = request.headers["X-Auth-Token"]
			@current_user = authenticated_user(remember_token)
		end
		@current_user
  end

  def log_in(user)
		remember user
		@current_user = user
	end

  def log_out
		current_user.forget
    @current_user = nil
  end

	def remember(user)
		user.remember
	end

	def authenticated_user(remember_token_value)

    return nil if remember_token_value.blank?

    remember_token = RememberToken.valid.find_by(token: remember_token_value)
    return nil if remember_token.nil?

    user = remember_token.user
    return user
	end

end
