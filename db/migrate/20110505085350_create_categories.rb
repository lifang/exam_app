class CreateCategories < ActiveRecord::Migration
  def self.up
    create_table :categories do |t|
      t.string :name
      t.integer :parent_id
    end
    add_index :categories,:parent_id
    add_index :categories,:name
  end

  def self.down
    drop_table :categories
  end
end
