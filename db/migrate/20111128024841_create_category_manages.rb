class CreateCategoryManages < ActiveRecord::Migration
  def self.up
    create_table :category_manages do |t|
      t.integer :category_id, :null => false
      t.integer :user_id
      t.datetime :created_at
    end
    add_index :category_manages,:category_id
    add_index :category_manages,:user_id
  end

  def self.down
    drop_table :category_manages
  end
end
