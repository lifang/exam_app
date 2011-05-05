class CreateExaminationPaperRelations < ActiveRecord::Migration
  def self.up
    create_table :examination_paper_relations do |t|
      t.integer :examination_id
      t.paper_id :paper_id
      t.timestamps
    end
    add_index :examination_paper_relations,:examination_id
    add_index :examination_paper_relations,:paper_id
  end

  def self.down
    drop_table :examination_paper_relations
  end
end
