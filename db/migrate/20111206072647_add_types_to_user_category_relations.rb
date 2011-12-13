class AddTypesToUserCategoryRelations < ActiveRecord::Migration
  def self.up
    add_column :user_category_relations, :types, :integer
    add_index :user_category_relations, :types
  end

  def self.down
    remove_column :user_category_relations, :types
  end
end
