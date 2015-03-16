require 'date'

class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  # GET /users
  # GET /users.json
  def index
    @users = User.all
  end

  def fitbit_login
    config = get_API_keys
    config[:oauth][:token] = current_user.fitbit_token
    config[:oauth][:secret] = current_user.fitbit_secret
    config[:oauth][:user_id] = current_user.fitbit_user_id

    client = Fitgem::Client.new(config[:oauth])
 
    if config[:oauth][:token] && config[:oauth][:secret]
      begin
        access_token = client.reconnect(config[:oauth][:token], config[:oauth][:secret])
      rescue Exception => e
        puts "Error: Could not reconnect Fitgem::Client due to invalid keys in .fitgem.yml"
        exit
      end

      @user = current_user 
      @user.check_save_activities(client)
      @user.get_avatar(client)
      redirect_to "/users/#{current_user.id}"

    else
      request_token = client.request_token
      @@token = request_token.token
      @@secret = request_token.secret

      redirect_to "https://www.fitbit.com/oauth/authorize?oauth_token=#{@@token}"
    end
  end

  def fitbit_callback
    verifier = params[:oauth_verifier]
    config = get_API_keys
 
    client = Fitgem::Client.new(config[:oauth])
     
    begin
      access_token = client.authorize(@@token, @@secret, { :oauth_verifier => verifier })
    rescue Exception => e
      puts "Error: Could not authorize Fitgem::Client with supplied oauth verifier"
      exit
    end

    user_id = client.user_info['user']['encodedId']
    config[:oauth].merge!(:token => access_token.token, :secret => access_token.secret, :user_id => user_id)
    
    @user = User.find(current_user.id)
    @user.fitbit_token = config[:oauth][:token]
    @user.fitbit_secret = config[:oauth][:secret]
    @user.fitbit_user_id = config[:oauth][:user_id]
    @user.save
   
    @user.check_save_activities(client)
    @user.get_avatar(client)

    redirect_to "/users/#{current_user.id}"
  end

  # GET /users/1
  # GET /users/1.json
  def show
    if params[:duration]
      num = params[:duration].to_i
      @fitbit_info = @user.activity_totals(num)
    end

    respond_to do |format|
      format.html
      format.json { render json: @fitbit_info }
    end

  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      # if user sucessfully created,
      # log them in and send them to OAuth
      # ajax call in welcome.js will redirect to users/fitbitlogin
      if @user.save
        token = SecureRandom.urlsafe_base64
        session[:session_token] = token
        @user.session_token = token
        @user.save
        format.html { redirect_to fitbit_login_path }
        format.json { render json: {created: true} }

      else
        format.html { render :new }
        format.json { render json: {created: false, errors: @user.errors, status: :unprocessable_entity } }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
end
