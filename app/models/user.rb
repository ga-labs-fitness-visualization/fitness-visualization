class User < ActiveRecord::Base

	has_many :daily_activities
end
