class AddLevelToWords < ActiveRecord::Migration
  def self.up
    add_column :words, :level, :integer
    add_index :words, :level
  end

  def self.down
    remove_column :words, :level
  end
end
