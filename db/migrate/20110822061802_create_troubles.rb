class CreateTroubles < ActiveRecord::Migration
  def self.up
    create_table :troubles do |t|
      t.integer :exam_user_id
      t.integer :problem_id
      t.string :content
      t.string :answer
      
      t.timestamps
    end
  end

  def self.down
    drop_table :troubles
  end
end
