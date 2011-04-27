class CreateQuestions < ActiveRecord::Migration
  def self.up
    create_table :questions do |t|
      t.integer :question_category_id
      t.string :title
      t.integer :types
      t.boolean :is_used

      t.timestamps
    end
    add_index :questions, :question_category_id
  end

  def self.down
    drop_table :questions
  end
end

