class AddPreferencesToUsers < ActiveRecord::Migration
  def change
    add_column :users, :preferences, :json
  end
end
