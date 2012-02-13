class AddDescriptionToReportErrors < ActiveRecord::Migration
  def self.up
    add_column :report_errors, :description, :string
  end

  def self.down
    drop_table :report_errors
  end
end
