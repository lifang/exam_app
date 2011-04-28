class RemovePasswordConfirmationToUser < ActiveRecord::Migration
  def self.up
    remove_column :users, :password_confirmation
  end

  def self.down
    add_column :users, :password_confirmation, :string
  end
end
