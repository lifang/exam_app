class CreateExamPlans < ActiveRecord::Migration
  def self.up
    create_table :exam_plans do |t|
      t.integer :examnation_id 
      t.datetime :start_at_time
      t.integer :creater_id
      t.string :description
      t.datetime :start_end_time
      t.datetime :exam_time

      t.timestamps
    end
  end

  def self.down
    drop_table :exam_plans
  end
end
