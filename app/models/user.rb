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

  def get_activity_dates
    return self.daily_activities.map { |a| a.date }
  end

  def check_save_activities(client)
    i = 0
    while i <= 30
      date = Date.today
      new_date = date - i
        unless (new_date != Date.today) && (self.get_activity_dates.include? new_date)
          if (new_date == Date.today) && (DailyActivity.find_by(date: Date.today))
            DailyActivity.find_by(date: Date.today).destroy
          end
          formatted_date = new_date.strftime("%Y-%m-%d")
          fitbit_userinfo_hash = client.activities_on_date new_date
          
          DailyActivity.create(
            user_id: self.id,
            date: new_date,
            floors: fitbit_userinfo_hash['summary']['floors'],
            distance: fitbit_userinfo_hash['summary']['distances'][0]['distance']
            )
        end
      i += 1
    end
  end

  def activity_totals(num)
    activity_totals = {
        floors: 0,
        miles: 0
      }
    activities = self.daily_activities.order(date: :desc).limit(num)
    activities.each do |activity|
      activity_totals[:floors] += activity.floors
      activity_totals[:miles] += activity.distance
    end
    return activity_totals
  end

end
