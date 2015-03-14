class AddFitbitUserIdToUsers < ActiveRecord::Migration
  def change
    add_column :users, :fitbit_user_id, :string
  end
end
