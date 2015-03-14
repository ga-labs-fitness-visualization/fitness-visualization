json.extract! @user, :id, :name, :created_at, :updated_at

json.set! @user.daily_activities.limit(30)
