class IpTable < ActiveRecord::Migration
  def self.up
    create_table :ip_tables do |t|
      t.string :start_at
      t.string :end_at
    end
  end

  def self.down
    drop_table :ip_tables
  end
end
