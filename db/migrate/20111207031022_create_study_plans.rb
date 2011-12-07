class CreateStudyPlans < ActiveRecord::Migration
  def self.up
    create_table :study_plans do |t|
      t.integer :study_date
      t.integer :task_types
      t.integer :period_types
      t.integer :task_num
      t.timestamp
    end
    add_index :study_plans, :task_types
    add_index :study_plans, :period_types
  end

  def self.down
    drop_table :study_plans
  end
end
