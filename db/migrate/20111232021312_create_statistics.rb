class CreateStatistics < ActiveRecord::Migration
  def self.up
    create_table :statistics do |t|
      t.datetime :created_at
      t.string :register
      t.string :action
      t.string :pay
      t.string :money
      t.string :login
    end
    add_index :statistics,:created_at
  end

  def self.down
    drop_table :statistics
  end
end
