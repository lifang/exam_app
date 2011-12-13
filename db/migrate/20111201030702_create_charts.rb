class CreateCharts < ActiveRecord::Migration
  def self.up
    create_table :charts do |t|
       t.integer :types
       t.string :image_url
      t.timestamps
    end
  end

  def self.down
    drop_table :charts
  end
end
