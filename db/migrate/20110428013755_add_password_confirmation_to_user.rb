class AddPasswordConfirmationToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :password_confirmation, :string
  end

  def self.down
    remove_column :users, :password_confirmation
  end
end
