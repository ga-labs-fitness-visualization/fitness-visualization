require 'date'

class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  # GET /users
  # GET /users.json
  def index
    @users = User.all
  end

  # GET /users/1
  # GET /users/1.json
  def show
    
    # When we get html to render page, there won't be params[:duration]
    # so the if block is needed to let the html page load
    if params[:duration]
      num = params[:duration].to_i
      api_array = get_date_strings(num)
      # I think the whole API call will have to go here
      # inside the IF block
    end

  # FIT BIT API CALL AND OATH AUTHENITFICATION   
    # Load the existing yml config
config = begin
  Fitgem::Client.symbolize_keys(YAML.load(File.open("lib/fitgem.yml")))
rescue ArgumentError => e
  puts "Could not parse YAML: #{e.message}"
  exit
end
 
client = Fitgem::Client.new(config[:oauth])
 
# With the token and secret, we will try to use them
# to reconstitute a usable Fitgem::Client
if config[:oauth][:token] && config[:oauth][:secret]
  begin
    access_token = client.reconnect(config[:oauth][:token], config[:oauth][:secret])
  rescue Exception => e
    puts "Error: Could not reconnect Fitgem::Client due to invalid keys in .fitgem.yml"
    exit
  end
# Without the secret and token, initialize the Fitgem::Client
# and send the user to login and get a verifier token
else
  request_token = client.request_token
  token = request_token.token
  secret = request_token.secret
 
  puts "Go to https://www.fitbit.com/oauth/authorize?oauth_token=#{token} and then enter the verifier code below"
  verifier = gets.chomp
 
  begin
    access_token = client.authorize(token, secret, { :oauth_verifier => verifier })
  rescue Exception => e
    puts "Error: Could not authorize Fitgem::Client with supplied oauth verifier"
    exit
  end
 
  puts 'Verifier is: '+verifier
  puts "Token is:    "+access_token.token
  puts "Secret is:   "+access_token.secret
 
  user_id = client.user_info['user']['encodedId']
  puts "Current User is: "+user_id
 
  config[:oauth].merge!(:token => access_token.token, :secret => access_token.secret, :user_id => user_id)
 
  # Write the whole oauth token set back to the config file
  File.open("fitgem.yml", "w") {|f| f.write(config.to_yaml) }
end
 
# ============================================================
# Add Fitgem API calls on the client object below this line

fitbit_userinfo_hash = client.activities_on_date '2015-03-03'
@user_total_distance = fitbit_userinfo_hash['summary']['distances'][0]['distance']
@user_total_floors = fitbit_userinfo_hash['summary']['floors']
binding.pry

@fitbit_info = {miles: @user_total_distance, floors: @user_total_floors}
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
      if @user.save
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
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
      params[:user]
    end
end
