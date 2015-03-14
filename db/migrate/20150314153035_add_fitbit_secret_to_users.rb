class AddFitbitSecretToUsers < ActiveRecord::Migration
  def change
    add_column :users, :fitbit_secret, :string
  end
end
