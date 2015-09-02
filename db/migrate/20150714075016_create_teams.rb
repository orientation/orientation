class CreateTeams < ActiveRecord::Migration
  def change
    create_table :teams do |t|
      t.string :name
      t.string :shtick
      t.string :slug

      t.timestamps
    end
  end
end
