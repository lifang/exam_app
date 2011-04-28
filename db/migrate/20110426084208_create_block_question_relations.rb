class CreateBlockQuestionRelations < ActiveRecord::Migration
  def self.up
    create_table :block_question_relations do |t|
      t.integer :question_id 
      t.integer :paper_block_id
      t.integer :score
      t.integer :assess_role
      t.boolean :is_in_used

    end
    add_index :block_question_relations, :question_id
    add_index :block_question_relations, :paper_block_id
  end

  def self.down
    drop_table :block_question_relations
  end
end
