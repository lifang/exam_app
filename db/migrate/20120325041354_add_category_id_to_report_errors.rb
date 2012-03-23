class AddCategoryIdToReportErrors < ActiveRecord::Migration
  def self.up
    add_column :report_errors, :category_id, :integer
    add_index :report_errors, :category_id
  end

  def self.down
    remove_column :report_errors, :category_id
  end
end
