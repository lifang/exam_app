class CreateQuestionTagRelations < ActiveRecord::Migration
  def self.up
    create_table :question_tag_relations do |t|
      t.integer :tag_id
      t.integer :question_id

      t.timestamps
    end
  end

  def self.down
    drop_table :question_tag_relations
  end
end
