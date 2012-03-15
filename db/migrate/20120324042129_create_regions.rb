class CreateRegions < ActiveRecord::Migration
  def self.up
    create_table :regions do |t|
      t.integer :city_index
      t.integer :parent_id
      t.string :name
    end
    add_index :regions,:name
    add_index :regions,:parent_id
    add_index :regions,:city_index
  end

  def self.down
    drop_table :regions
  end
end
