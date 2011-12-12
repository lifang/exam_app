class CreateWordDiscriminateRelations < ActiveRecord::Migration
  def self.up
    create_table :word_discriminate_relations do |t|
      t.integer :word_id
      t.integer :discriminate_id
      t.timestamps
    end
    add_index :word_discriminate_relations, :word_id
    add_index :word_discriminate_relations, :discriminate_id
  end

  def self.down
    drop_table :word_discriminate_relations
  end
end
