class CreateQuestions < ActiveRecord::Migration
  def self.up
    create_table :questions do |t|
      t.integer :problem_id
      t.string :description
      t.string :answer
      t.integer :correct_type
      t.text :analysis
      t.string :question_attrs
    end
    add_index :questions,:problem_id
    add_index :questions,:correct_type
  end

  def self.down
    drop_table :questions
  end
end
