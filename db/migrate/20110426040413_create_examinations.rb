class CreateExaminations < ActiveRecord::Migration
  def self.up
    create_table :examinations do |t|
      t.integer :paper_id 
      t.string :title
      t.integer :types
      t.string :description

      t.timestamps 
    end
    add_index :examinations, :paper_id
  end

  def self.down
    drop_table :examinations
  end
end
