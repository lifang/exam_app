class CreateOrders < ActiveRecord::Migration
  def self.up
    create_table :orders do |t|
      t.integer :user_id
      t.integer :types
      t.integer :total_price
      t.string  :remark
    end
    add_index :orders,:user_id
  end

  def self.down
    drop_table :orders
  end
end
