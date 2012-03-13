class CreateRegions < ActiveRecord::Migration
  def self.up
    create_table :regions do |t|
      t.string :name
      t.integer :parent_id
    end
    add_index :regions,:name
    add_index :regions,:parent_id
  end

  def self.down
    drop_table :regions
  end
end
