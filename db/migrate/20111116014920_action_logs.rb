class ActionLogs < ActiveRecord::Migration
  def self.up
    create_table :action_logs do |t|
      t.integer :user_id, :null => false
      t.integer :types
      t.integer :category_id
      t.string :remark
      t.timestamps
    end
    add_index :action_logs,:user_id
    add_index :action_logs,:type
    add_index :action_logs,:category_id
  end

  def self.down
    drop_table :action_logs
  end
end
