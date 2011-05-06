class CreateRaterUserRelations < ActiveRecord::Migration
  def self.up
    create_table :rater_user_relations do |t|
      t.integer :exam_user_id
      t.integer :exam_rater_id
      t.boolean :is_marked
      t.integer :examination_id
      t.timestamps
    end
  end

  def self.down
    drop_table :rater_user_relations
  end
end
