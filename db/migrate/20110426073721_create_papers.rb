class CreatePapers < ActiveRecord::Migration
  def self.up
    create_table :papers do |t|
      t.string :title
      t.string :types
      t.integer :creater_id
      t.string :description
      t.string :total_score
      t.integer :total_question_num

      t.timestamps
    end
  end    

  def self.down
    drop_table :papers
  end
end
