class SessionsController < ApplicationController
  def new
    @user = User.new

  end

  def create
    @user = User.find_by_credentials(session_params)
    if @user
      token = SecureRandom.urlsafe_base64
      session[:session_token] = token
      @user.session_token = token
      @user.save

      # redirect_to @user
      redirect_to fitbit_login_url
    else
      @user = User.new(email: session_params[:email])

      render :new
    end
  end

  def destroy
    @user = current_user
    token = SecureRandom.urlsafe_base64
    session[:session_token] = token
    
    if @user
      @user.session_token = nil
      @user.save
    end

    redirect_to login_path
  end

  private

  def session_params
    params.require(:user).permit(:email, :password)
  end

end
