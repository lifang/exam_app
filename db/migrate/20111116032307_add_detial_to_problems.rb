class AddDetialToProblems < ActiveRecord::Migration
  def self.up
    add_column :problems, :question_type, :integer
    add_index :problems,:question_type
    add_index :problems,:status
  end

  def self.down
    remove_column :problems, :question_type
  end
end
