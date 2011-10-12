class AddQuestionIdToFeedback < ActiveRecord::Migration
  def self.up
    add_index :feedbacks,:question_id
  end

  def self.down
    remove_index :feedbacks, :question_id
  end
end
