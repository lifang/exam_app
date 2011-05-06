class CreateExaminations < ActiveRecord::Migration
  def self.up
    create_table :examinations do |t|
      t.string :title
      t.integer :creater_id
      t.string :description
      t.boolean :is_score_open
      t.boolean :is_paper_open
      t.string :exam_password1
      t.string :exam_password2
      t.datetime :start_at_time
      t.datetime :start_end_time
      t.datetime :exam_time
      t.boolean :is_published
      
      t.timestamps
    end
    add_index :examinations,:creater_id
  end

  def self.down
    drop_table :examinations
  end
end
