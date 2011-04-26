class CreateRaterRecordRelations < ActiveRecord::Migration
  def self.up
    create_table :rater_record_relations do |t|
      t.integer :exam_record_id
      t.integer :exam_rater_id

      t.timestamps
    end
    add_index :rater_record_relations,:exam_record_id
    add_index :rater_record_relations,:exam_rater_id
  end

  def self.down
    drop_table :rater_record_relations
  end
end
