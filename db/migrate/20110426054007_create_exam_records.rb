class CreateExamRecords < ActiveRecord::Migration
  def self.up
    create_table :exam_records do |t|
      t.integer :exam_user_id
      t.integer :examination_id
      t.boolean :is_submited
      t.boolean :is_marked
      t.string :answer_sheet_url

      t.timestamps
    end
    add_index :exam_records,:exam_user_id
    add_index :exam_records,:examination_id
  end

  def self.down
    drop_table :exam_records
  end
end