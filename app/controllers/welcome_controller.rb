class WelcomeController < ApplicationController
  
  def welcome
    if current_user 
      # redirect_to current_user
      redirect_to fitbit_login
    else
      render :welcome, layout: false
    end

  end

end
