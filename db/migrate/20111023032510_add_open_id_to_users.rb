class AddOpenIdToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :open_id, :string
  end

  def self.down
    remove_column :users, :open_id
  end
end
