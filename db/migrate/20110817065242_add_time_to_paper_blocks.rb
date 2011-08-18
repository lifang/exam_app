class AddTimeToPaperBlocks < ActiveRecord::Migration
  def self.up
    add_column :paper_blocks, :time, :integer
  end

  def self.down
    remove_column :paper_blocks, :time
  end
end
