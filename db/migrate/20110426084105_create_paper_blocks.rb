class CreatePaperBlocks < ActiveRecord::Migration
  def self.up
    create_table :paper_blocks do |t|
      t.integer :paper_id
      t.string :title
      t.integer :types
      t.string :description
      t.integer :block_total_score

      t.timestamps
    end
  end

  def self.down
    drop_table :paper_blocks
  end
end