class GenerateSlugsForExistingTags < ActiveRecord::Migration
  class MigrationTag < ActiveRecord::Base
    self.table_name = "tags"

    extend FriendlyId

    friendly_id :name
  end

  def change
    MigrationTag.find_each do |t|
      # not using save! here because this could raise if the tag name matches
      # a reserved word. See config/initializers/friendly_id.rb for details.
      t.save
    end
  end
end
