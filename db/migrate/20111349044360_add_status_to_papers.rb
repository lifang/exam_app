class AddStatusToPapers < ActiveRecord::Migration
  def self.up
    add_column :papers, :status, :boolean
  end

  def self.down
    remove_column :papers, :status
  end
end
