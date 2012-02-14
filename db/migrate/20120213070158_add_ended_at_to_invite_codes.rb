class AddEndedAtToInviteCodes < ActiveRecord::Migration
  def self.up
    add_column :invite_codes, :ended_at, :datetime
  end

  def self.down
    remove_column :invite_codes, :ended_at
  end
end
