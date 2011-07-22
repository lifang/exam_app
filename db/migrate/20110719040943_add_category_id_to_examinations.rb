class AddCategoryIdToExaminations < ActiveRecord::Migration

  def self.up
    add_column :examinations, :category_id, :integer
  end

  def self.down
    remove_column :examinations, :category_id
  end
end
