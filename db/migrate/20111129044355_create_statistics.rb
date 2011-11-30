class CreateStatistics < ActiveRecord::Migration
  def self.up
    create_table :statistics do |t|
      t.datetime :created_at
      t.integer :register_num
      t.integer :action_num
      t.integer :pay_num
      t.integer :money_num
    end
    add_index :statistics,:created_at
  end

  def self.down
    drop_table :statistics
  end
end
