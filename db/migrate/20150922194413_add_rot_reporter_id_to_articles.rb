class AddRotReporterIdToArticles < ActiveRecord::Migration[4.2]
  def change
    add_column :articles, :rot_reporter_id, :integer
  end
end
