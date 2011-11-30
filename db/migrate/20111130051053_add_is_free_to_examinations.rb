class AddIsFreeToExaminations < ActiveRecord::Migration
  def self.up
    add_column :examinations, :is_free, :boolean
  end

  def self.down
    remove_column :examinations, :is_free
  end
end
