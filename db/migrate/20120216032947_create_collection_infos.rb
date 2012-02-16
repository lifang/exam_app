class CreateCollectionInfos < ActiveRecord::Migration
  def self.up
    create_table :collection_infos do |t|
      t.integer :paper_id
      t.integer :user_id
      t.text :question_ids
      t.datetime :created_at
    end
    add_index :collection_infos, :paper_id
    add_index :collection_infos, :user_id
  end

  def self.down
    drop_table :collection_infos
  end
end
