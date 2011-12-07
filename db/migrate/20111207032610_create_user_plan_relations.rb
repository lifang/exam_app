class CreateUserPlanRelations < ActiveRecord::Migration
  def self.up
    create_table :user_plan_relations do |t|
      t.integer :user_id
      t.integer :study_plan_id
      t.datetime :created_at
      t.datetime :ended_at
    end
    add_index :user_plan_relations, :user_id
    add_index :user_plan_relations, :study_plan_id
    add_index :user_plan_relations, :created_at
    add_index :user_plan_relations, :ended_at
  end

  def self.down
    drop_table :user_plan_relations
  end
end
