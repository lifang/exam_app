class AddCategoryIdToCollections < ActiveRecord::Migration
  def self.up
    add_column :collections, :category_id, :integer
  end

  def self.down
    remove_column :collections, :category_id
  end
end
