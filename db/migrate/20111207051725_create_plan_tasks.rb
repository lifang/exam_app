class CreatePlanTasks < ActiveRecord::Migration
  def self.up
    create_table :plan_tasks do |t|
      t.integer :study_plan_id
      t.integer :task_types
      t.integer :period_types
      t.integer :num
      t.datetime :created_at
    end
    add_index :plan_tasks, :study_plan_id
    add_index :plan_tasks, :task_types
    add_index :plan_tasks, :period_types
  end

  def self.down
    drop_table :plan_tasks
  end
end
