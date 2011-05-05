class CreatePapers < ActiveRecord::Migration
  def self.up
    create_table :papers do |t|
      t.integer :category_id
      t.text :title
      t.integer :creater_id
      t.string :description
      t.integer :total_score
      t.integer :total_question_num
      t.boolean :is_used
      t.string :paper_url

      t.timestamps
    end
  end

  def self.down
    drop_table :papers
  end
end
