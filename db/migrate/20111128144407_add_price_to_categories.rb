class AddPriceToCategories < ActiveRecord::Migration
  def self.up
  add_column :categories, :price, :float, :defalut => 0
  end

  def self.down
    remove_column :categories, :price
  end
end
