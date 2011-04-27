class CreateBlockQuestionRelations < ActiveRecord::Migration
  def self.up
    create_table :block_question_relations do |t|
      t.integer :question_id 
      t.integer :paper_id
      t.integer :score

    end
    add_index :block_question_relations, :question_id
    add_index :block_question_relations, :paper_id
  end

  def self.down
    drop_table :block_question_relations
  end
end
