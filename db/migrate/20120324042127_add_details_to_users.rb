class AddDetailsToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :access_token, :string
    add_column :users, :end_time, :datetime
  end

  def self.down
    remove_column :users, :access_token
    remove_column :users, :end_time
  end
end
