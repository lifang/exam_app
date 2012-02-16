class AddCategoryIdToInviteCode < ActiveRecord::Migration
  def self.up
    add_column :invite_codes, :category_id, :integer
  end

  def self.down
    remove_column :invite_codes, :category_id
  end
end
