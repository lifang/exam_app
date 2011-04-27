class CreateQuestionTagRelations < ActiveRecord::Migration
  def self.up
    create_table :question_tag_relations do |t|
      t.integer :tag_id
      t.integer :question_id   
    end
    add_index :question_tag_relations, :tag_id
    add_index :question_tag_relations, :question_id
  end

  def self.down
    drop_table :question_tag_relations
  end
end


