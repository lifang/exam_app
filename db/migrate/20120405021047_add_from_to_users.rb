class AddFromToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :from, :integer
    add_index :users, :from
  end

  def self.down
    remove_column :users, :from
  end
end
