class AddCategoryIdToFeedbacks < ActiveRecord::Migration
  def self.up
    add_column :feedbacks, :category_id, :integer
  end

  def self.down
    remove_column :feedbacks, :category_id
  end
end
