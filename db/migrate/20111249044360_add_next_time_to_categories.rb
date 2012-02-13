class AddNextTimeToCategories < ActiveRecord::Migration
  def self.up
    add_column :categories, :next_time, :datetime
  end

  def self.down
    remove_column :categories, :next_time
  end
end
