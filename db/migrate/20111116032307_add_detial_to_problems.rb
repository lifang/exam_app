class AddDetialToProblems < ActiveRecord::Migration
  def self.up
    add_column :problems, :question_type, :integer
    add_column :problems, :course_id, :integer
    add_index :problems,:question_type
    add_index :problems,:status
    add_index :problems,:course_id
  end

  def self.down
    remove_column :problems, :question_type
  end
end
