class StatisticData < ActiveRecord::Migration
  def self.up
    create_table :statistic_data do |t|
      t.datetime :created_at
      t.integer :register_num
      t.integer :action_num
      t.integer :pay_num
      t.integer :money_num
    end
    add_index :statistic_data,:created_at
  end

  def self.down
    drop_table :statistic_data
  end
end
