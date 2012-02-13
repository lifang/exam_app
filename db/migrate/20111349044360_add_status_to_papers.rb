class AddStatusToPapers < ActiveRecord::Migration
  def self.up
    add_column :papers, :status, :boolean
    add_index :papers, :status
  end

  def self.down
    remove_column :papers, :status
  end
end
