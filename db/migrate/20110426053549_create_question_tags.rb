class CreateQuestionTags < ActiveRecord::Migration
  def self.up
    create_table :question_tags do |t|
      t.integer :total_num
      t.integer :question_id

      t.timestamps
    end
    add_index :question_tags,:question_id
  end

  def self.down
    drop_table :question_tags
  end
end
