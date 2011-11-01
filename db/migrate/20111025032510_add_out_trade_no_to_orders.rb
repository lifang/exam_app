class AddOutTradeNoToOrders < ActiveRecord::Migration
  def self.up
    add_column :orders, :out_trade_no, :string
  end

  def self.down
    remove_column :orders, :out_trade_no
  end
end
