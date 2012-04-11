class AddIsActivityToUserPlanRelations < ActiveRecord::Migration
  def self.up
    add_column :user_plan_relations, :is_activity, :boolean, :default => 0
    add_index :user_plan_relations, :is_activity
  end

  def self.down
    remove_column :user_plan_relations, :is_activity
  end
end
