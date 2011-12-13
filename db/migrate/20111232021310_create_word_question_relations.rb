class CreateWordQuestionRelations < ActiveRecord::Migration
  def self.up
    create_table :word_question_relations do |t|
      t.integer :word_id
      t.integer :question_id
      t.timestamps
    end
    add_index :word_question_relations, :word_id
    add_index :word_question_relations, :question_id
  end

  def self.down
    drop_table :word_question_relations
  end
end
