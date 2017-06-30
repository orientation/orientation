class AddPreferencesToUsers < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :preferences, :json
  end
end
