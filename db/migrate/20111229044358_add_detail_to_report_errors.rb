class AddDetailToReportErrors < ActiveRecord::Migration
  def self.up
    add_column :report_errors, :question_id, :integer
    add_column :report_errors, :status, :integer,:default=>0
  end

  def self.down
    remove_column :report_errors, :question_id
    remove_column :report_errors, :status
  end
end
