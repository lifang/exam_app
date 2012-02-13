class AddStatusToInviteCode < ActiveRecord::Migration
  def self.up
    add_column :invite_codes, :status, :integer
  end

  def self.down
    remove_column :invite_codes, :status
  end
end
