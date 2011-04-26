class CreateExamRaters < ActiveRecord::Migration
  def self.up
    create_table :exam_raters do |t|
      t.integer :exam_plan_id
      t.string :name
      t.string :password
      t.string :mobilephone
      t.string :email

      t.timestamps
    end
    add_index :exam_raters,:exam_plan_id
  end

  def self.down
    drop_table :exam_raters
  end
end
