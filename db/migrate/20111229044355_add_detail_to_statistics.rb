class AddDetailToStatistics < ActiveRecord::Migration
  def self.up
    drop_table :statistics
    create_table :statistics do |t|
      t.datetime :created_at
      t.integer :register
      t.integer :action
      t.integer :pay
      t.integer :money
    end
    add_index :statistics,:created_at
  end

  def self.down
    drop_table :statistics
  end
end
