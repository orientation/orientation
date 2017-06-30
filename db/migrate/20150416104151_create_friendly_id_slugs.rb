class CreateFriendlyIdSlugs < ActiveRecord::Migration[4.2]
  class MigrationArticle < ActiveRecord::Base
    self.table_name = :articles
  end

  def change
    create_table :friendly_id_slugs do |t|
      t.string   :slug,           :null => false
      t.integer  :sluggable_id,   :null => false
      t.string   :sluggable_type, :limit => 50
      t.string   :scope
      t.datetime :created_at
    end
    add_index :friendly_id_slugs, :sluggable_id
    add_index :friendly_id_slugs, [:slug, :sluggable_type]
    add_index :friendly_id_slugs, [:slug, :sluggable_type, :scope], :unique => true
    add_index :friendly_id_slugs, :sluggable_type

    # This will generate a FriendlyId slug for all existing cached slugs in
    # order to not create 404s when/if article titles are ever changed.
    say_with_time "Migrating existing slugs to FriendlyId" do
      MigrationArticle.all.each(&:save!)
    end
  end
end
