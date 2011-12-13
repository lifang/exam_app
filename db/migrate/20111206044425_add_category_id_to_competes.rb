class AddCategoryIdToCompetes < ActiveRecord::Migration
  def self.up
    add_column :competes, :category_id, :integer
    add_index :competes, :category_id
  end

  def self.down
    remove_column :competes, :category_id
  end
end
