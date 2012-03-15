class AddDetailToIpTables < ActiveRecord::Migration
  def self.up
    add_column :ip_tables, :province_name, :string
    add_column :ip_tables, :city_name, :string
  end

  def self.down
    remove_column :ip_tables, :province_name
    remove_column :ip_tables, :city_name
  end
end
