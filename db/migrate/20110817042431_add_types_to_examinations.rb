class AddTypesToExaminations < ActiveRecord::Migration
  def self.up
    add_column :examinations, :types, :integer
  end

  def self.down
    remove_column :examinations, :types
  end
end
