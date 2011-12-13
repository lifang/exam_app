class AddDetailToReportErrors < ActiveRecord::Migration
  def self.up
    add_column :report_errors, :question_id, :integer
    add_column :report_errors, :status, :boolean
  end

  def self.down
    drop_table :report_errors
  end
end
