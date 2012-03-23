class AddDetialToUserPlanRelations < ActiveRecord::Migration
  def self.up
    add_column :user_plan_relations, :num, :integer, :default => 1
    add_column :user_plan_relations, :status, :boolean, :default => 1
    add_index :user_plan_relations, :num
    add_index :user_plan_relations, :status
  end

  def self.down
    remove_column :user_plan_relations, :num
    remove_column :user_plan_relations, :status
  end
end
