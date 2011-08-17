class AddIsShouldRateToExaminations < ActiveRecord::Migration
  def self.up
    add_column :examinations, :is_should_rate, :boolean
  end

  def self.down
    remove_column :examinations, :is_should_rate
  end
end
