class Buses < ActiveRecord::Migration
  def self.up
    create_table :buses do |t|
      t.string :num
      t.datetime :created_at
    end
    add_index :buses, :num
  end

  def self.down
    drop_table :buses
  end
end
