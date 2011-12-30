class CreateUserWordRelations < ActiveRecord::Migration
  def self.up
    create_table :user_word_relations do |t|
      t.datetime :created_at
      t.integer :user_id
      t.integer :word_id
    end
    add_index :user_word_relations,:user_id
    add_index :user_word_relations,:word_id
  end

  def self.down
    drop_table :user_word_relations
  end
end
