class RemoveAuthors < ActiveRecord::Migration
  def change
    drop_table :authors
  end
end
