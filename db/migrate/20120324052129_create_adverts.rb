class CreateAdverts < ActiveRecord::Migration
  def self.up
    create_table :adverts do |t|
      t.string :content
      t.integer :region_id
      t.datetime :created_at
    end
    add_index :adverts,:region_id
  end

  def self.down
    drop_table :adverts
  end
end
