class CreateQuestionPoints < ActiveRecord::Migration
  def self.up
    create_table :question_points do |t|
      t.integer :question_id
      t.string :description
      t.string :answer
      t.integer :correct_type
    end
  end

  def self.down
    drop_table :question_points
  end
end
