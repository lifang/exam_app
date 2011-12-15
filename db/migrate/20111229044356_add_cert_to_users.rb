class AddCertToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :cert, :string
  end

  def self.down
    remove_column :users, :cert
  end
end
