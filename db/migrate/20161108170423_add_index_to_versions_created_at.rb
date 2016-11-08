class AddIndexToVersionsCreatedAt < ActiveRecord::Migration[5.0]
  def change
    add_index :versions, :created_at
  end
end
