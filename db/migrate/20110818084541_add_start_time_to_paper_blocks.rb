class AddStartTimeToPaperBlocks < ActiveRecord::Migration
  def self.up
    add_column :paper_blocks, :start_time, :datetime
  end

  def self.down
    remove_column :paper_blocks, :start_time
  end
end
