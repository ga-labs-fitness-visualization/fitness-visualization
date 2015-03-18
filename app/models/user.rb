class User < ActiveRecord::Base

	has_many :daily_activities, dependent: :destroy

  has_secure_password

  def self.find_by_credentials(args = {})
    user = User.find_by(email: args[:email])
    return nil unless user
    if user.is_password?(args[:password])
      return user
    else
      return nil
    end
  end

  def is_password?(pwd)
    correct_password = BCrypt::Password.new(self.password_digest)
    return correct_password.is_password?(pwd)
  end

  # issue
  def self.get_leaders(type, duration)
    users = User.all
    users.sort_by { |u| u.activity_totals(duration)[type.to_sym] }.reverse!
  end

  def get_activity_dates
    return self.daily_activities.map { |a| a.date }
  end

  def get_today_activities(client)
    # first destroy previous saves of today's activity
    activities = self.daily_activities
    activities.each do |activity|
      if activity.date == Date.today
      activity.destroy
      end
    end

    # then get latest activity for today & save to db
    today = Date.today.strftime("%Y-%m-%d")
    fitbit_activities_hash = client.activities_on_date today

    DailyActivity.create(
      user_id: self.id,
      date: today,
      floors: fitbit_activities_hash['summary']['floors'] || 0,
      distance: fitbit_activities_hash['summary']['distances'][0]['distance'],
      calories: fitbit_activities_hash['summary']['activityCalories']
      )
  end

  def check_save_activities(client)
    i = 1
    while i <= 31
      date = Date.today
      new_date = date - i
        unless self.get_activity_dates.include? new_date
          formatted_date = new_date.strftime("%Y-%m-%d")
          fitbit_activities_hash = client.activities_on_date new_date
          
          DailyActivity.create(
            user_id: self.id,
            date: new_date,
            floors: fitbit_activities_hash['summary']['floors'] || 0,
            distance: fitbit_activities_hash['summary']['distances'][0]['distance'],
            calories: fitbit_activities_hash['summary']['activityCalories']
            )
        end
      i += 1
    end
  end

  def get_avatar(client)
    fitbit_userinfo_hash = client.user_info
    self.avatar =fitbit_userinfo_hash["user"]["avatar150"]
    self.save
  end

  def activity_totals(num)
    activity_totals = {
        floors: 0,
        miles: 0,
        calories: 0
      }
    activities = self.daily_activities.order(date: :desc).limit(num)
    activities.each do |activity|
      activity_totals[:floors] += activity.floors
      activity_totals[:miles] += activity.distance
      activity_totals[:calories] += activity.calories
    end
    return activity_totals
  end

end
