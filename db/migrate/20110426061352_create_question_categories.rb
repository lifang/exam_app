class CreateQuestionCategories < ActiveRecord::Migration
  def self.up
    create_table :question_categories do |t|
      t.string :name
    end
  end

  def self.down
    drop_table :question_categories
  end
end
