class CreateScoreLevels < ActiveRecord::Migration
  def self.up
    create_table :score_levels do |t|
      t.integer :examination_id
      t.string :key
      t.string :value

      t.timestamps
    end
    add_index :score_levels,:examination_id
  end

  def self.down
    drop_table :score_levels
  end
end
