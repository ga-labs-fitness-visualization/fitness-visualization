class DailyActivities < ActiveRecord::Migration
  def change
  	   create_table :daily_activities do |t|
    	t.references :user
    	t.date :date
    	t.integer :floors
    	t.float :distance

      t.timestamps null: false
    end 
  end
end
