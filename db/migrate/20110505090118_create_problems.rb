class CreateProblems < ActiveRecord::Migration
  def self.up
    create_table :problems do |t|
      t.integer :category_id
      t.text :title
      t.integer :types

      t.timestamps
    end
    add_index :problems,:category_id
    add_index :problems,:types
  end

  def self.down
    drop_table :problems
  end
end