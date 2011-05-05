class CreateScoreLevels < ActiveRecord::Migration
  def self.up
    create_table :score_levels do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :score_levels
  end
end
