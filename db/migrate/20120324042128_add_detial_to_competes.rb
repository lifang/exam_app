class AddDetialToCompetes < ActiveRecord::Migration
  def self.up
    remove_column :competes, :pirce
    add_column :competes, :price, :integer
  end

  def self.down
    add_column :competes, :pirce, :integer
    remove_column :competes, :price
  end
end
