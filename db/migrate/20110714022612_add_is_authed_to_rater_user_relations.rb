class AddIsAuthedToRaterUserRelations < ActiveRecord::Migration
  def self.up
    add_column :rater_user_relations, :is_authed, :boolean, :default => 0
    add_column :rater_user_relations, :started_at, :datetime
    add_column :rater_user_relations, :rate_time, :integer
    add_index :rater_user_relations, :is_authed
  end

  def self.down
    remove_column :rater_user_relations, :is_authed
    remove_column :rater_user_relations, :started_at
    remove_column :rater_user_relations, :rate_time
  end
end
