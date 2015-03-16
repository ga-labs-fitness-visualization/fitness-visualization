class AddCaloriesToDailyActivities < ActiveRecord::Migration
  def change
    add_column :daily_activities, :calories, :integer
  end
end
