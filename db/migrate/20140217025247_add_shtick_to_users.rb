class AddShtickToUsers < ActiveRecord::Migration
  def change
    add_column :users, :shtick, :text
  end
end
