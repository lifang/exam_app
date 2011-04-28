class CreatePaperCategories < ActiveRecord::Migration
  def self.up
     create_table :paper_categories do |t|
      t.string :name

      t.timestamps
    end
  end

  def self.down
    drop_table :block_question_relations
  end
end
