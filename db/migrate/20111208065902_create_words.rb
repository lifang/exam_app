class CreateWords < ActiveRecord::Migration
  def self.up
    create_table :words do |t|
      t.string :name
      t.integer :category_id
      t.string :en_mean
      t.string :ch_mean
      t.string :types
      t.timestamps
    end
    add_index :words, :name
    add_index :words, :category_id
  end

  def self.down
    drop_table :words
  end
end
