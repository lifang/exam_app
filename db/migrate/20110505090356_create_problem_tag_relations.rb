class CreateProblemTagRelations < ActiveRecord::Migration
  def self.up
    create_table :problem_tag_relations do |t|
      t.integer :tag_id
      t.integer :problem_id

      t.timestamps
    end
  end

  def self.down
    drop_table :problem_tag_relations
  end
end
