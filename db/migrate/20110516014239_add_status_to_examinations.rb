class AddStatusToExaminations < ActiveRecord::Migration
  def self.up
    add_column :examinations, :status, :integer
  end

  def self.down
    remove_column :examinations, :status
  end
end
