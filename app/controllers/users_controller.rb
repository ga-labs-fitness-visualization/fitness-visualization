require 'date'

class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  # GET /users
  # GET /users.json
  def index
    @users = User.all
  end

  def fitbit_login
    # FIT BIT API CALL AND OATH AUTHENITFICATION   
    # Load the existing yml config
    config = begin
      Fitgem::Client.symbolize_keys(YAML.load(File.open("lib/fitgem.yml")))
    rescue ArgumentError => e
      puts "Could not parse YAML: #{e.message}"
      exit
    end

    config[:oauth][:token] = current_user.fitbit_token
    config[:oauth][:secret] = current_user.fitbit_secret
    config[:oauth][:user_id] = current_user.fitbit_user_id

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

      @user = current_user 
      activities = @user.daily_activities
      activity_dates = activities.map do |activity|
        activity.date
      end
      
      i = 0
      while i <= 30
        date = Date.today
        new_date = date - i

        if activity_dates.include? new_date
          puts "we have an activity for #{new_date}"
        else
          formatted_date = new_date.strftime("%Y-%m-%d")
          fitbit_userinfo_hash = client.activities_on_date new_date
          
          DailyActivity.create({
            user_id: @user.id,
            date: new_date,
            floors: fitbit_userinfo_hash['summary']['floors'],
            distance: fitbit_userinfo_hash['summary']['distances'][0]['distance']
            })
        end
        i += 1
      end
      binding.pry
      render :show

    # Without the secret and token, initialize the Fitgem::Client
    # and send the user to login and get a verifier token
    else
      request_token = client.request_token
      @@token = request_token.token
      @@secret = request_token.secret

      redirect_to "https://www.fitbit.com/oauth/authorize?oauth_token=#{@@token}"
    end
  end

  def fitbit_callback
    verifier = params[:oauth_verifier]
    # mb: copied these lines from above
    config = begin
      Fitgem::Client.symbolize_keys(YAML.load(File.open("lib/fitgem.yml")))
    rescue ArgumentError => e
      puts "Could not parse YAML: #{e.message}"
      exit
    end
 
    client = Fitgem::Client.new(config[:oauth])
     
    begin
      access_token = client.authorize(@@token, @@secret, { :oauth_verifier => verifier })
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
    
    @user = User.find(current_user.id)
    @user.fitbit_token = config[:oauth][:token]
    @user.fitbit_secret = config[:oauth][:secret]
    @user.fitbit_user_id = config[:oauth][:user_id]
    @user.save
   
    # Write the whole oauth token set back to the config file
    # mb: for some reason this line is not writing the new token to the file
    # mb: probably OK since we will want to save this info in the users db anyway?
    File.open("fitgem.yml", "w") {|f| f.write(config.to_yaml) }

    redirect_to "/users/#{current_user.id}"
  end

  # GET /users/1
  # GET /users/1.json
  def show
    # mb: commented this out for now
    # mb: not sure how much will need to be put back (not here but as a helper, called here) in order to initiate API calls

    # FIT BIT API CALL AND OATH AUTHENITFICATION   
    # Load the existing yml config
#     config = begin
#       Fitgem::Client.symbolize_keys(YAML.load(File.open("lib/fitgem.yml")))
#     rescue ArgumentError => e
#       puts "Could not parse YAML: #{e.message}"
#       exit
#     end
 
#     client = Fitgem::Client.new(config[:oauth])
 
#     # With the token and secret, we will try to use them
#     # to reconstitute a usable Fitgem::Client
#     if config[:oauth][:token] && config[:oauth][:secret]
#       begin
#         access_token = client.reconnect(config[:oauth][:token], config[:oauth][:secret])
#       rescue Exception => e
#         puts "Error: Could not reconnect Fitgem::Client due to invalid keys in .fitgem.yml"
#         exit
#       end
#     # Without the secret and token, initialize the Fitgem::Client
#     # and send the user to login and get a verifier token
#     else
#       request_token = client.request_token
#       token = request_token.token
#       secret = request_token.secret
     
#       puts "Go to https://www.fitbit.com/oauth/authorize?oauth_token=#{token} and then enter the verifier code below"
#       verifier = gets.chomp
     
#       begin
#         access_token = client.authorize(token, secret, { :oauth_verifier => verifier })
#       rescue Exception => e
#         puts "Error: Could not authorize Fitgem::Client with supplied oauth verifier"
#         exit
#       end
 
#       puts 'Verifier is: '+verifier
#       puts "Token is:    "+access_token.token
#       puts "Secret is:   "+access_token.secret
     
#       user_id = client.user_info['user']['encodedId']
#       puts "Current User is: "+user_id
     
#       config[:oauth].merge!(:token => access_token.token, :secret => access_token.secret, :user_id => user_id)
     
#       # Write the whole oauth token set back to the config file
#       File.open("fitgem.yml", "w") {|f| f.write(config.to_yaml) }
#     end
 
# # ============================================================
# # Add Fitgem API calls on the client object below this line

    if params[:duration]
      num = params[:duration].to_i
      api_array = get_date_strings(num)
      all_activities = {
        floors: 0,
        miles: 0
      }
      api_array.each do |day|
        fitbit_userinfo_hash = client.activities_on_date day
        all_activities[:floors] += fitbit_userinfo_hash['summary']['floors']
        all_activities[:miles] += fitbit_userinfo_hash['summary']['distances'][0]['distance']

      end

      @fitbit_info = {miles: all_activities[:miles], floors: all_activities[:floors]}

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
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
end
