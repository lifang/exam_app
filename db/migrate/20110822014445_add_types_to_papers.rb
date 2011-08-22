class AddTypesToPapers < ActiveRecord::Migration
  def self.up
    add_column :papers, :types, :integer
    add_index:papers, :types
  end

  def self.down
    remove_column :papers, :types
  end
end
