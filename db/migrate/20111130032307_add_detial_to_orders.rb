class AddDetialToOrders < ActiveRecord::Migration
  def self.up
    add_column :orders, :category_id, :integer
  end

  def self.down
    remove_column  :orders, :category_id
  end
end
