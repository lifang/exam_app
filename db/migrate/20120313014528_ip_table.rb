class IpTable < ActiveRecord::Migration
  def self.up
    create_table :ip_tables do |t|
      t.string :start_at
      t.string :end_at
      t.string :city
    end
    add_index :ip_tables,:start_at
    add_index :ip_tables,:end_at
  end

  def self.down
    drop_table :ip_tables
  end
end
