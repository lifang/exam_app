class CreateStudyPlans < ActiveRecord::Migration
  def self.up
    create_table :study_plans do |t|
      t.integer :category_id
      t.integer :study_date
      t.timestamp
    end
    add_index :study_plans, :category_id
  end

  def self.down
    drop_table :study_plans
  end
end
