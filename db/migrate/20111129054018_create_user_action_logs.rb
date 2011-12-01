class CreateUserActionLogs < ActiveRecord::Migration
  def self.up
    create_table :user_action_logs do |t|
      t.integer :user_id
      t.string :total_num
      t.integer :week_num
      t.datetime :last_update_time
      t.timestamps
    end
    add_index :user_action_logs,:user_id
  end

  def self.down
    drop_table :user_action_logs
  end
end
