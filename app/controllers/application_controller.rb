class ApplicationController < ActionController::Base
  
	helper_method :current_user

	def current_user
		return nil unless session[:session_token]
		User.find_by(session_token: session[:session_token])
	end

  def get_date_strings(num)
		i = 1
		date_strings_array = []
		while (i <= num)
			date = Date.today
			new_date = date - i
			formatted_date = new_date.strftime("%Y-%m-%d")
			date_strings_array << formatted_date
			i += 1
		end 
		return date_strings_array
	end 
	
  protect_from_forgery with: :exception
end
