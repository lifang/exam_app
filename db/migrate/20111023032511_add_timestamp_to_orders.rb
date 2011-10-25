class AddTimestampToOrders < ActiveRecord::Migration
  def self.up
    add_column :orders,:created_at,:datetime
  end

  def self.down
    remove_column :orders,:created_at
  end
end
