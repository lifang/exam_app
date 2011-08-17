class AddDetailToOrders < ActiveRecord::Migration
  def self.up
    add_column :orders, :start_time, :datetime
    add_column :orders, :end_time, :datetime
    add_column :orders, :status, :boolean
  end

  def self.down
    remove_column :orders, :start_time
    remove_column :orders, :end_time
    remove_column :orders, :status
  end
end
