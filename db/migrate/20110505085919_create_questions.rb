class CreateQuestions < ActiveRecord::Migration
  def self.up
    create_table :questions do |t|
      t.integer :problem_id, :null => false
      t.text :description
      t.text :answer
      t.integer :correct_type, :default => 0
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
