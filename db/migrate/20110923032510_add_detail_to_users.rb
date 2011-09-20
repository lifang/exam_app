class AddDetailToUsers < ActiveRecord::Migration
  def self.up
    remove_column :users, :belief
    add_column :users, :belief_url, :string
  end

  def self.down
    remove_column :users, :belief
    add_column :users, :belief_url, :integer
  end
end
