class AddRotReporterIdToArticles < ActiveRecord::Migration
  def change
    add_column :articles, :rot_reporter_id, :integer
  end
end
