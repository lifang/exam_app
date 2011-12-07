class CreateStudyPlanUsers < ActiveRecord::Migration
  def self.up
    create_table :study_plan_users do |t|
      t.integer :user_id
      t.datetime :created_at
      t.datetime :ended_at
    end
    add_index :study_plan_users, :user_id
    add_index :study_plan_users, :created_at
    add_index :study_plan_users, :ended_at
  end

  def self.down
    drop_table :study_plan_users
  end
end
