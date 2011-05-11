class AddDefaultToExaminationPaperRelations < ActiveRecord::Migration
  def self.up
    add_column :examination_paper_relations, :default, :boolean
  end

  def self.down
    remove_column :examination_paper_relations, :default
  end
end
