class ApplicationController < ActionController::Base
  
	helper_method :current_user
	protect_from_forgery with: :exception

	def current_user
		return nil unless session[:session_token]
		User.find_by(session_token: session[:session_token])
	end

	def get_API_keys
		begin
      Fitgem::Client.symbolize_keys(YAML.load(File.open("lib/fitgem.yml")))
    rescue ArgumentError => e
      puts "Could not parse YAML: #{e.message}"
      exit
    end
	end

	# is anything still using this method?
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
	
  
end
