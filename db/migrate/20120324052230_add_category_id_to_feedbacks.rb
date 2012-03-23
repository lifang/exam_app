class AddCategoryIdToFeedbacks < ActiveRecord::Migration
  def self.up
    remove_column :feedbacks, :question_id
    add_column :feedbacks, :category_id, :integer
    add_index :feedbacks, :category_id
  end

  def self.down
    remove_column :feedbacks, :category_id
    add_column :feedbacks, :question_id, :integer
  end
end
