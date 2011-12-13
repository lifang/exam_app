class CreateNotices < ActiveRecord::Migration
  def self.up
    create_table :notices do |t|
      t.integer :category_id
      t.datetime :started_at
      t.datetime :ended_at
      t.integer :send_types
      t.integer :send_id
      t.integer :target_id
      t.string :description
      t.datetime :created_at
    end
    add_index :notices, :started_at
    add_index :notices, :ended_at
    add_index :notices, :send_types
    add_index :notices, :send_id
    add_index :notices, :target_id
    add_index :notices, :category_id
  end

  def self.down
    drop_table :notices
  end
end
