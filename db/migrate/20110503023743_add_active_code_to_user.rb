class AddActiveCodeToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :active_code, :number
  end

  def self.down
    remove_column :users, :active_code
  end
end
