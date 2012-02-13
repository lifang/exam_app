class CreateVicegerents < ActiveRecord::Migration
  def self.up
    create_table :vicegerents do |t|
      t.string :name
      t.string :phone
      t.string :inline
      t.string :address
      t.datetime :created_at
    end
    add_index :vicegerents, :name
  end

  def self.down
    drop_table :vicegerents
  end
end
