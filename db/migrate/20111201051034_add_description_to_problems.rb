class AddDescriptionToProblems < ActiveRecord::Migration
  def self.up
    add_column :problems, :description, :string
  end

  def self.down
    remove_column :problems, :description
  end
end
