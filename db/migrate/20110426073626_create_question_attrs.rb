class CreateQuestionAttrs < ActiveRecord::Migration
  def self.up
    create_table :question_attrs do |t|
      t.integer :question_point_id
      t.string :key
      t.string :value    

      t.timestamps
    end
    add_index :question_attrs, :question_point_id
  end

  def self.down
    drop_table :question_attrs
  end
end
