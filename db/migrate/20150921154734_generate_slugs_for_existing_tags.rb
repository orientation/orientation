class GenerateSlugsForExistingTags < ActiveRecord::Migration
  class MigrationTag < ActiveRecord::Base
    self.table_name = "tags"

    extend FriendlyId

    friendly_id :name
  end

  def change
    MigrationTag.find_each do |t|
      t.save!
    end
  end
end
