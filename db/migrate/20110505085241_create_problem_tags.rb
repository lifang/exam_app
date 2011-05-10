class CreateProblemTags < ActiveRecord::Migration
  def self.up
    create_table :problem_tags do |t|
      t.integer :problem_id
      t.integer :total_num


    end
    add_index :problem_tags,:problem_id
  end

  def self.down
    drop_table :problem_tags
  end
end