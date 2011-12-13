class CreateUserCategoryRelations < ActiveRecord::Migration
  def self.up
    create_table :user_category_relations do |t|
      t.integer :user_id
      t.integer :category_id
      t.integer :status
      t.datetime :created_at
    end
    add_index :user_category_relations, :user_id
    add_index :user_category_relations, :category_id
    add_index :user_category_relations, :status
  end

  def self.down
    drop_table :user_category_relations
  end
end
