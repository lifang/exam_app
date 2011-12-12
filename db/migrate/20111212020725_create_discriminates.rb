class CreateDiscriminates < ActiveRecord::Migration
  def self.up
    create_table :discriminates do |t|
      t.text :description
      t.timestamps
    end
  end

  def self.down
    drop_table :discriminates
  end
end
