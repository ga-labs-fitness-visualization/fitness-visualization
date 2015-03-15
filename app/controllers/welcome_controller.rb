class WelcomeController < ApplicationController
  
  def welcome
    if current_user 
      redirect_to current_user
    else
      render :welcome, layout: false
    end

  end

end
