class CreatePhoneWords < ActiveRecord::Migration
  def self.up
    create_table :phone_words do |t|
      t.string :name
      t.integer :category_id
      t.string :ch_mean
      t.integer :types
      t.string :phonetic
      t.string :enunciate_url
      t.integer :level
      t.timestamps
    end
    add_index :phone_words, :name
    add_index :phone_words, :category_id
  end

  def self.down
    drop_table :phone_words
  end
end
