class RemoveAuthors < ActiveRecord::Migration[4.2]
  def change
    drop_table :authors
  end
end
