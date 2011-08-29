class AddQuestionIdToFeedback < ActiveRecord::Migration
  def self.up
    add_column :feedbacks, :question_id, :integer
  end

  def self.down
    remove_column :feedbacks, :question_id
  end
end
