class CreateExamnations < ActiveRecord::Migration
  def self.up
    create_table :examnations do |t|
      t.integer :paper_id 
      t.string :title
      t.integer :type
      t.string :description

      t.timestamps
    end
  end

  def self.down
    drop_table :examnations
  end
end
