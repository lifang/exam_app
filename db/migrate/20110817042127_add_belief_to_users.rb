class AddBeliefToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :belief, :integer
  end

  def self.down
    remove_column :users, :belief
  end
end
