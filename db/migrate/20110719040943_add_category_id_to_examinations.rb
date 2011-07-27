class AddCategoryIdToExaminations < ActiveRecord::Migration

  def self.up
    add_column :examinations, :category_id, :integer
    add_index :examinations, :category_id
  end

  def self.down
    remove_column :examinations, :category_id
  end
end
