class CreateWordSentences < ActiveRecord::Migration
  def self.up
    create_table :word_sentences do |t|
      t.integer :word_id
      t.string :description
      t.timestamps
    end
    add_index :word_sentences, :word_id
  end

  def self.down
    drop_table :word_sentences
  end
end
