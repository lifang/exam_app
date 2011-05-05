class CreateExaminationPaperRelations < ActiveRecord::Migration
  def self.up
    create_table :examination_paper_relations do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :examination_paper_relations
  end
end
