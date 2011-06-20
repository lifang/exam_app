class CreateCollections < ActiveRecord::Migration
  def self.up
    create_table :collections do |t|
      t.integer :user_id, :null => false
      t.string :collection_url, :null => false
    end
    add_index :collections,:user_id
  end

  def self.down
    drop_table :collections
  end
end
