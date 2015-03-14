class AddFitbitTokenToUsers < ActiveRecord::Migration
  def change
    add_column :users, :fitbit_token, :string
  end
end
