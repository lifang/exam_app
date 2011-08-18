class AddCodeIdToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :code_id, :integer
    add_column :users, :code_type,:string
    add_index :users, :code_id
    add_index :users, :code_type
  end

  def self.down
    remove_column :users, :code_id
     remove_column :users, :code_type
  end
end