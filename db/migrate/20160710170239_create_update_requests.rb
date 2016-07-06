class CreateUpdateRequests < ActiveRecord::Migration
  def change
    create_table :update_requests do |t|
      t.integer :article_id
      t.integer :reporter_id
      t.text :description

      t.timestamps
    end
  end
end
