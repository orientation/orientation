class RenameRotReporterIdToOudatednessReporterId < ActiveRecord::Migration[5.0]
  def change
    rename_column :articles, :rot_reporter_id, :outdatedness_reporter_id
  end
end
