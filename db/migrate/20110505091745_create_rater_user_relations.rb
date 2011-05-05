class CreateRaterUserRelations < ActiveRecord::Migration
  def self.up
    create_table :rater_user_relations do |t|
      t.integer :exam_user_id
      t.integer :exam_rater_id
      t.boolean :is_marked

      t.timestamps
      add_index :rater_user_relations,:exam_user_id
      add_index :rater_user_relations,:exam_rater_id
      add_index :rater_user_relations,:examination_id
    end
  end

  def self.down
    drop_table :rater_user_relations
  end
end
