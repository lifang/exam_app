class AddPayTypeToOrders < ActiveRecord::Migration
  def self.up
    add_column :orders, :pay_type, :integer
    add_index :orders, :pay_type
    add_index :orders, :out_trade_no
  end

  def self.down
    remove_column :orders, :pay_type
  end
end
