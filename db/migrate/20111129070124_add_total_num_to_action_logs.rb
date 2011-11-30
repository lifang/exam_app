class AddTotalNumToActionLogs < ActiveRecord::Migration
  def self.up
    add_column :action_logs, :total_num, :integer
  end

  def self.down
    remove_column :action_logs, :total_num
  end
end
