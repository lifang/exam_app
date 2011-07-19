class CreateOrders < ActiveRecord::Migration
  def self.up
    create_table:orders do |t|
      t.integer :user_id
      t.integer :types
      t.integer :total_price
      t.string  :remark
    end
  end

  def self.down
    drop_table :orders
  end
end