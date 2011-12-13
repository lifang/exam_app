class CreateExaminationTagRelations < ActiveRecord::Migration
  def self.up
    create_table :examination_tag_relations do |t|
      t.integer :examination_id
      t.integer :tag_id
    end
    add_index :examination_tag_relations, :examination_id
    add_index :examination_tag_relations, :tag_id
  end

  def self.down
    drop_table :examination_tag_relations
  end
end
