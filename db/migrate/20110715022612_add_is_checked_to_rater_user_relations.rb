class AddIsCheckedToRaterUserRelations < ActiveRecord::Migration
  def self.up
    add_column :rater_user_relations, :is_checked, :boolean, :default => 0
    add_index :rater_user_relations, :is_checked
  end

  def self.down
    remove_column :rater_user_relations, :is_checked
  end
end
