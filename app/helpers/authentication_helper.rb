# encoding: utf-8
module AuthenticationHelper

	DEFAULT_EXPIRE_TIME = 30.minutes
	REMEMBER_EXPIRE_TIME = 30.days

	def authenticated?
		session[:user_id].present? && !session_expired?
	end

	def authenticate user_id
		session[:user_id] = user_id
		touch_session_expire!
	end

	def deauthenticate!
		session[:user_id] = nil
		unset_session_expire!
	end

	def me? user_model
		authenticated? && session[:user_id] == user_model.id
	end

	def show_backend?
		authenticated? && controller_name != :login && action_name != :new
	end

	protected

	def session_expired?
		session[:expires_at].present? && session[:expires_at] < Time.now
	end

	def touch_session_expire!
		session[:expires_at] = Time.now + (session[:remember].present? ? REMEMBER_EXPIRE_TIME : DEFAULT_EXPIRE_TIME)
	end

	def unset_session_expire!
		session[:expires_at] = nil
	end

end
