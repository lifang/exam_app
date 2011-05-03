class AddStatusToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :status, :boolean
  end

  def self.down
    remove_column :users, :status
  end
end
