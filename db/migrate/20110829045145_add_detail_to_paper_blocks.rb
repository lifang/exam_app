class AddDetailToPaperBlocks < ActiveRecord::Migration
  def self.up
    remove_column :paper_blocks, :start_time
    add_column :paper_blocks, :start_time, :string
  end

  def self.down
    remove_column :paper_blocks, :start_time
    add_column :paper_blocks, :start_time, :datetime
  end
end
