class AddCorrectPercentToExamUsers < ActiveRecord::Migration
  def self.up
    add_column :exam_users, :correct_percent, :integer
  end

  def self.down
    remove_column :exam_users, :correct_percent
  end
end
