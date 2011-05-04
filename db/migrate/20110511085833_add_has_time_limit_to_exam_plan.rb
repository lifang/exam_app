class AddHasTimeLimitToExamPlan < ActiveRecord::Migration
  def self.up
    add_column :exam_plans, :has_time_limit, :boolean
  end

  def self.down
     remove_column :exam_plans, :has_time_limit
  end
end
