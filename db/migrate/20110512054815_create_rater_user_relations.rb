class CreateRaterUserRelations < ActiveRecord::Migration
  def self.up
    create_table :rater_user_relations do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :rater_user_relations
  end
end
