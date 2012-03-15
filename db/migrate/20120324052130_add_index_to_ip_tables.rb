class AddIndexToIpTables < ActiveRecord::Migration
  def self.up
    add_index :user_word_relations, :category_id
    add_index :ip_tables, :start_at
    add_index :ip_tables, :end_at
    add_index :ip_tables, :city_name
    add_index :ip_tables, :province_name
  end

  def self.down
  end
end
