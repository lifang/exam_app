class CreateCharts < ActiveRecord::Migration
  def change
    create_table :charts do |t|
       t.integer :types
       t.string :image_url
      t.timestamps
    end
  end
end
