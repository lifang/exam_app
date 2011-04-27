class CreateExamnations < ActiveRecord::Migration
  def self.up
    create_table :examnations do |t|
      t.integer :paper_id 
      t.string :title
      t.integer :types
      t.string :description

      t.timestamps 
    end
    add_index :examnations, :paper_id
  end

  def self.down
    drop_table :examnations
  end
end
