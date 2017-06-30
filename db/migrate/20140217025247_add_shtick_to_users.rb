class AddShtickToUsers < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :shtick, :text
  end
end
